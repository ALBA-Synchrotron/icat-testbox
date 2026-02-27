import pytest

from config import Config


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
    return Config()


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()
