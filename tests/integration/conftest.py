import pytest
from docker import DockerClient

from config import Config
from utils import before_start


@pytest.fixture()
def app(monkeypatch):
    from app import create_app
    app = create_app()
    app.config.update({
        "TESTING": True,
    })

    yield app


@pytest.fixture(scope="session")
def config():
    config: Config = Config()
    config.db_container_name = f"{config.db_container_name}_unittest"
    config.database_port = 33307
    before_start(config)

    yield config

    dc: DockerClient = config.get_docker_client()
    dc.containers.get(config.db_container_name).remove(force=True, v=True)


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()
