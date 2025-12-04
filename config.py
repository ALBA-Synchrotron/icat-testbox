import json
import os
import re

import docker
from packaging.version import Version


class Config:
    icat_testbox_instance_name: str
    config_file_path: str
    database_port: int
    default_database: str
    docker_socket_path: str

    def __init__(self) -> None:
        self.icat_testbox_instance_name = os.getenv("ICAT_TESTBOX_INSTANCE_NAME", "icat_testbox_0")
        self.config_file_path = os.getenv("CONFIG_FILE_PATH", "config.json")
        self.database_port = int(os.getenv("DATABASE_PORT", "33306"))
        self.default_database = os.getenv("DEFAULT_DATABASE", "mariadb")
        self.docker_socket_path = os.getenv("DOCKER_SOCKET_PATH", "/var/run/docker.sock")

        self.__load_config_file()

    def __load_config_file(self) -> None:
        config: dict = {}
        if not os.path.exists(self.config_file_path):
            raise FileNotFoundError(f"Config file not found at {self.config_file_path}")

        with open(self.config_file_path, "r") as f:
            config = json.load(f)

        if not config:
            raise ValueError("Config file is empty")

        if "databases" not in config:
            raise KeyError("databases key not found in config file")
        self.databases = config["databases"]

        if "fixtures_mapping" not in config:
            raise KeyError("fixtures key not found in config file")
        self.fixtures_mapping = config["fixtures_mapping"]

    def get_docker_client(self) -> docker.DockerClient:
        return docker.DockerClient(base_url=f"unix://{self.docker_socket_path}")

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
