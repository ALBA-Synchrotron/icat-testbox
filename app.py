import json

from flask import Flask, Response, request

from config import Config
from databases import provision_new_icat_database
from utils import before_start, random_identifier_generator

config = Config()
before_start(config)
app: Flask = Flask(__name__)


@app.route("/", methods=["GET"])
def hello_world() -> Response:
    return Response("<p>Hello, World!</p>", status=200)


@app.route("/new_icat_testbox_instance", methods=["POST"])
def provision_icat_testbox_instance() -> Response:
    try:
        req_data: dict = json.loads(request.data.decode())
        load_fixtures: bool = req_data.get("load_fixtures", False)
        icat_version: str = req_data.get("icat_version", "")

        if not icat_version:
            return Response("icat_version is required", status=400)

        identifier = f"{config.icat_testbox_instance_name}_{random_identifier_generator()}"
        provision_new_icat_database(config, identifier, icat_version, load_fixtures)

        ret: dict = {
            "identifier": identifier
        }

        return Response(json.dumps(ret), status=200)
    except Exception as e:
        return Response(str(e), status=500)
