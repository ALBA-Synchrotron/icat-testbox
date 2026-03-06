from docker import DockerClient

from config import Config

ENDPOINT_NAME: str = "app.create_testbox"


def test_db_container_created(config):
    dc: DockerClient = config.get_docker_client()
    db_container = dc.containers.get(config.db_container_name)
    assert db_container.status == "running"


def test_db_user_created(config):
    dc: DockerClient = config.get_docker_client()
    commands: list = ["mariadb", "-e", "SELECT User, Host FROM mysql.user"]
    db_container = dc.containers.get(config.db_container_name)
    exit_code, output = db_container.exec_run(commands)
    assert exit_code == 0
    db_username, _ = config.get_default_db_credentials()
    assert db_username in output.decode()
