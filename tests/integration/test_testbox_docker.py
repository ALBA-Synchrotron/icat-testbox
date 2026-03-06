import json

import pytest
from docker import DockerClient
from docker.errors import NotFound
from docker.models.containers import Container
from flask import url_for

from databases import get_db_names

CREATE_ENDPOINT_NAME: str = "app.create_testbox"
RELOAD_ENDPOINT_NAME: str = "app.reload_testbox"
DELETE_ENDPOINT_NAME: str = "app.delete_testbox"


def test_testbox_lifecycle_docker(app, client, config):
    body: dict = {
        "icat_version": "6.2.0",
        "init_database": True,
        "authn_db_version": "3.0.0"
    }
    with app.test_request_context():
        url: str = url_for(CREATE_ENDPOINT_NAME)
        response = client.post(url, data=json.dumps(body), content_type="application/json")
    assert response.status_code == 200
    identifier: str = response.json.get("identifier", "")
    container_id: str = response.json.get("container_id", "")

    dc: DockerClient = config.get_docker_client()
    container: Container = dc.containers.get(container_id)
    assert container.status == "running"

    db_container = dc.containers.get(f"{config.icat_testbox_instance_name}_db")

    server_db_name, authn_db_name = get_db_names(identifier)
    exit_code, output = db_container.exec_run(["mariadb", "-e", "SHOW DATABASES"])
    assert exit_code == 0
    assert server_db_name in output.decode()
    assert authn_db_name in output.decode()

    exit_code, output = db_container.exec_run(["mariadb", "-e", f"DROP TABLES {authn_db_name}.PASSWD;"])
    assert exit_code == 0
    exit_code, output = db_container.exec_run(["mariadb", "-e", f"SHOW TABLES FROM {authn_db_name};"])
    assert exit_code == 0
    assert "PASSWD" not in output.decode()

    with app.test_request_context():
        url: str = url_for(RELOAD_ENDPOINT_NAME, identifier=identifier)
        response = client.post(url)
        assert response.status_code == 200

    exit_code, output = db_container.exec_run(["mariadb", "-e", f"SHOW TABLES FROM {authn_db_name};"])
    assert exit_code == 0
    assert "PASSWD" in output.decode()

    with app.test_request_context():
        url: str = url_for(DELETE_ENDPOINT_NAME, identifier=identifier)
        response = client.delete(url)
        assert response.status_code == 200

    with pytest.raises(NotFound):
        _: Container = dc.containers.get(container_id)

    exit_code, output = db_container.exec_run(["mariadb", "-e", "SHOW DATABASES"])
    assert exit_code == 0
    assert server_db_name not in output.decode()
    assert authn_db_name not in output.decode()

