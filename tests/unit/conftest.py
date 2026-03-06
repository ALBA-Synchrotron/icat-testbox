from unittest.mock import patch, MagicMock

import pytest
from docker.errors import NotFound

from config import Config


@pytest.fixture()
def docker_container_mock():
    mock_container = MagicMock()
    mock_container.exec_run.return_value = (0, b"")
    mock_container.id = "asd1234"
    mock_container.name = "testbox1"
    mock_container.status = "running"
    mock_container.labels = {"identifier": "testbox1", "icat_version": "6.2.0", "authn_db_version": "3.0.0"}
    yield mock_container


@pytest.fixture()
def docker_client_mock(docker_container_mock):
    with patch("docker.DockerClient") as DockerClientMock:
        mock_containers = MagicMock()

        def fake_get(name: str):
            if name == "icat-test-box_non-existent":
                raise NotFound(f"Container {name} not found")
            return docker_container_mock

        mock_containers.get.side_effect = fake_get
        mock_containers.run.return_value = docker_container_mock
        mock_containers.list.return_value = [docker_container_mock]
        DockerClientMock.return_value.containers = mock_containers

        yield DockerClientMock


@pytest.fixture()
def app(monkeypatch, docker_client_mock):
    from app import create_app
    app = create_app()
    app.config.update({
        "TESTING": True,
    })

    monkeypatch.setattr(Config, "get_docker_client", docker_client_mock)

    yield app


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()
