import json
import logging
import os
import random
import re
from json import JSONDecodeError

import docker
from packaging.version import Version, InvalidVersion


logger: logging.Logger = logging.getLogger(__name__)

class Config:
    icat_testbox_instance_name: str
    config_file_path: str
    database_port: int
    default_database: str
    host_db_name: str
    docker_socket_path: str
    containers_port_range: str
    access_token: str | None
    scheduler_enabled: bool
    clean_job_timer: int
    max_instance_lifetime: int
    log_level: str

    def __init__(self) -> None:
        self.icat_testbox_instance_name = os.getenv("ICAT_TESTBOX_INSTANCE_NAME", "icat_testbox_0")
        self.config_file_path = os.getenv("CONFIG_FILE_PATH", "config.json.example")
        self.database_port = int(os.getenv("DATABASE_PORT", "33306"))
        self.host_db_name = os.getenv("HOST_DB_NAME", "host.docker.internal")
        self.default_database = os.getenv("DEFAULT_DATABASE", "mariadb")
        self.docker_socket_path = os.getenv("DOCKER_SOCKET_PATH", "/var/run/docker.sock")
        self.containers_port_range = os.getenv("CONTAINERS_PORT_RANGE", "50000-55000")
        self.access_token = os.getenv("ACCESS_TOKEN", None)
        self.scheduler_enabled = os.getenv("SCHEDULER_ENABLED", "true").lower() == "true"
        self.clean_job_timer = int(os.getenv("SCHEDULER_CLEAN_TIMER", 20))
        self.max_instance_lifetime = int(os.getenv("MAX_INSTANCE_LIFETIME", 30))
        self.log_level = os.getenv("LOG_LEVEL", "INFO")

        self.__load_config_file()

    def __load_config_file(self) -> None:
        config: dict = {}
        if not os.path.exists(self.config_file_path):
            raise FileNotFoundError(f"Config file not found at {self.config_file_path}")

        try:
            with open(self.config_file_path, "r") as f:
                config = json.load(f)
        except (OSError, JSONDecodeError) as e:
            raise OSError(f"Error reading config file: {e}")

        if not config:
            raise ValueError("Config file is empty")

        if "databases" not in config:
            raise KeyError("databases key not found in config file")
        self.databases = config["databases"]

        if "fixtures_mapping" not in config:
            raise KeyError("fixtures key not found in config file")
        self.fixtures_mapping = config["fixtures_mapping"]

        if "payara_images" not in config:
            raise KeyError("payara_images key not found in config file")
        self.payara_images = config["payara_images"]

    def get_docker_client(self) -> docker.DockerClient:
        return docker.DockerClient(base_url=f"unix://{self.docker_socket_path}")

    def component_versions_supported(self, component_versions: dict) -> bool:
        ret: list = []
        for component, version in component_versions.items():
            try:
                _ = self.get_fixtures_file(component, version)
                ret.append(True)
            except InvalidVersion:
                ret.append(False)
        return all(ret)

    def get_fixtures_file(self, component: str, component_version: str) -> str:
        if self.default_database not in self.fixtures_mapping:
            raise KeyError(f"fixtures_mapping for {self.default_database} not found")
        if component not in self.fixtures_mapping[self.default_database]:
            raise KeyError(f"fixtures_mapping for {component} not found")

        fixtures_opts: dict = self.fixtures_mapping[self.default_database][component]

        for rule, value in fixtures_opts.items():
            if version_matches(rule, component_version):
                return value
        return ""

    def get_payara_image(self, component_versions: dict) -> tuple[str, int]:
        for component_version_str, image_config in self.payara_images.items():
            components: list = component_version_str.split("|")
            versions = [i.split(" ") for i in components if len(i.split(" ")) == 3]

            if all(version_matches(f"{i[1]} {i[2]}", component_versions[i[0]]) for i in versions):
                return image_config["image"], image_config["port"]
        raise ValueError("No matching image found for the requested versions")

    def get_db_jar_client(self, db_type: str = "") -> str:
        if db_type and db_type in self.databases:
            return self.databases[db_type]["jar_client"]
        return self.databases[self.default_database]["jar_client"]

    def get_default_db_credentials(self, db_type: str = "") -> tuple[str, str]:
        if db_type and db_type in self.databases:
            return self.databases[db_type]["user"], self.databases[db_type]["password"]
        return self.databases[self.default_database]["user"], self.databases[self.default_database]["password"]

    def get_available_port(self, feeling_lucky: bool = False) -> int:
        if feeling_lucky:
            return random.randint(20000, 65000)

        low, high = self.containers_port_range.split("-")
        dc: docker.DockerClient = self.get_docker_client()
        running_test_boxes = [i.labels for i in dc.containers.list(
            filters={"label": ["type=icat-testbox"]}) if isinstance(i.labels, dict)]
        busy_ports = [int(i["host_port"]) for i in running_test_boxes if "host_port" in i]

        logger.info(f"Busy ports (accepted range {low}-{high}): {busy_ports}")

        return next(i for i in range(int(low), int(high)) if i not in busy_ports)


def version_matches(rule, version):
    op, rule_version = re.match(r"(<=|>=|<|>|==)\s*(.+)", rule).groups()
    v = Version(version)
    rv = Version(rule_version)

    return {
        "<": v < rv,
        "<=": v <= rv,
        ">": v > rv,
        ">=": v >= rv,
        "==": v == rv,
    }[op]
