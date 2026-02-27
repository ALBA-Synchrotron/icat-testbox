from flask import url_for
import messages as msg

ENDPOINT_NAME: str = "app.hello_world"

def test_status(app, client):
    with app.test_request_context():
        url: str = url_for(ENDPOINT_NAME)
        response = client.get(url)

        assert response.status_code == 200
        assert "msg" in response.json
        assert msg.STATUS_OK in response.json.get("msg", "")
