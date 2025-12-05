import datetime

import docker
from docker.models.containers import Container

from config import Config


def provision_database_container(config: Config) -> Container:
    dc: docker.DockerClient = config.get_docker_client()
    container_config: dict = config.databases[config.default_database]

    image = container_config.get("image", None)
    db_port = container_config.get("port", None)
    host_port = config.database_port
    db_env = container_config.get("env", {})
    container_env = [f"{i}={db_env[i]}" for i in db_env]

    if not image or not db_port:
        raise ValueError("Invalid database configuration")
    return dc.containers.run(image=image, name=f"{config.icat_testbox_instance_name}_db", detach=True,
                             ports={f"{db_port}/tcp": host_port}, environment=container_env)


def provision_new_icat_testbox(config: Config, identifier: str, icat_version: str, authn_db_version: str,
                               icat_server_schema_name: str, icat_authn_db_schema_name: str) -> dict:
    dc: docker.DockerClient = config.get_docker_client()
    try:
        payara_image, payara_port = config.get_payara_image({"icat_server": icat_version, "authn_db": authn_db_version})

        environment_vars: list = [
            f"DB_JAR_CLIENT={config.get_db_jar_client()}"
            f"ICAT_SERVER_VERSION={icat_version}",
            f"ICAT_AUTHN_DB_VERSION={authn_db_version}",
            f"DB_TYPE={config.default_database}",
            f"DB_HOSTNAME={config.icat_testbox_instance_name}_db",
            f"DB_HOST_PORT={config.database_port}",
            f"ICAT_SERVER_DB_SCHEMA_NAME={icat_server_schema_name}",
            f"ICAT_AUTHN_DB_SCHEMA_NAME={icat_authn_db_schema_name}"
        ]

        host_port: int = config.get_available_port()
        print(f"Free host port found: {host_port}")

        container_labels: dict = {
            "owner": config.icat_testbox_instance_name,
            "type": "icat-testbox",
            "identifier": identifier,
            "creation_date": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            "icat_version": icat_version,
            "authn_db_version": authn_db_version,
            "host_port": str(host_port)
        }

        container: Container = dc.containers.run(image=payara_image, name=f"icat-test-box_{identifier}", detach=True,
                                                 environment=environment_vars, labels=container_labels,
                                                 ports={f"{payara_port}/tcp": host_port})
        print(f"New icat testbox provisioned successfully, container id: {container.id} name: {container.name}")
        return {**container_labels, "container_id": container.id, "container_name": container.name}
    except Exception as e:
        print(f"Error provisioning new icat testbox: {e}")
