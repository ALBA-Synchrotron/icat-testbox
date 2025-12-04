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

