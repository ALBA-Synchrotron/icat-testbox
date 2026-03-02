import json
import messages as msg

from flask import url_for

ENDPOINT_NAME: str = "app.create_testbox"

def test_create_no_payload(app, client):
    with app.test_request_context():
        url: str = url_for(ENDPOINT_NAME)
        response = client.post(url)
    assert response.status_code == 400
    assert "msg" in response.json
    assert msg.ERR_INVALID_PAYLOAD in response.json.get("msg", "")


def test_create_missing_versions(app, client):
    body: dict = {
        "icat_version": "6.2.0",
        "init_database": True
    }
    with app.test_request_context():
        url: str = url_for(ENDPOINT_NAME)
        response = client.post(url, data=json.dumps(body), content_type="application/json")
    assert response.status_code == 400
    assert "msg" in response.json
    assert msg.ERR_MISSING_VERSIONS in response.json.get("msg", "")


def test_create_invalid_versions(app, client):
    body: dict = {
        "icat_version": "6.2.0",
        "init_database": True,
        "authn_db_version": "99.99.99ASD"
    }
    with app.test_request_context():
        url: str = url_for(ENDPOINT_NAME)
        response = client.post(url, data=json.dumps(body), content_type="application/json")
    assert response.status_code == 400
    assert "msg" in response.json
    assert msg.ERR_INVALID_VERSIONS in response.json.get("msg", "")

def test_create_valid_versions(app, client):
    body: dict = {
        "icat_version": "6.2.0",
        "init_database": True,
        "authn_db_version": "3.0.0"
    }
    with app.test_request_context():
        url: str = url_for(ENDPOINT_NAME)
        response = client.post(url, data=json.dumps(body), content_type="application/json")
    assert response.status_code == 200
    assert "container_name" in response.json
    assert "container_id" in response.json