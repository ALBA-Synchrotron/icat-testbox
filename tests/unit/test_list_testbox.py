from flask import url_for

ENDPOINT_NAME: str = "app.list_testboxes"

def test_list_containers(app, client):
    with app.test_request_context():
        url: str = url_for(ENDPOINT_NAME)
        response = client.get(url)
    assert response.status_code == 200
    assert type(response.json) == list