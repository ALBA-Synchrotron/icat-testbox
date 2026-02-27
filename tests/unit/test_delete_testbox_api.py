
import messages as msg

from flask import url_for

ENDPOINT_NAME: str = "app.delete_testbox"

def test_delete_non_existent(app, client):
    with app.test_request_context():
        url: str = url_for(ENDPOINT_NAME, identifier="non-existent")
        response = client.delete(url)
    assert response.status_code == 404
    assert "msg" in response.json
    assert msg.ERR_NOT_FOUND in response.json.get("msg", "")

def test_delete(app, client):
    with app.test_request_context():
        url: str = url_for(ENDPOINT_NAME, identifier="yes-existent")
        response = client.delete(url)
    assert response.status_code == 200
    assert "msg" in response.json
    assert msg.TESTBOX_DELETED in response.json.get("msg", "")