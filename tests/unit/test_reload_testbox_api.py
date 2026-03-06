
import messages as msg

from flask import url_for

ENDPOINT_NAME: str = "app.reload_testbox"

def test_reload_non_existent(app, client):
    with app.test_request_context():
        url: str = url_for(ENDPOINT_NAME, identifier="non-existent")
        response = client.post(url)
    assert response.status_code == 404
    assert "msg" in response.json
    assert msg.ERR_NOT_FOUND in response.json.get("msg", "")

def test_reload(app, client):
    with app.test_request_context():
        url: str = url_for(ENDPOINT_NAME, identifier="yes-existent")
        response = client.post(url)
    assert response.status_code == 200
    assert "msg" in response.json
    assert msg.TESTBOX_DB_RELOADED in response.json.get("msg", "")