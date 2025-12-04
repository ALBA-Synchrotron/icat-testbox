import json

from flask import Flask, Response, request

from config import Config
from databases import provision_new_icat_databases
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
        init_database: bool = req_data.get("load_fixtures", True)
        icat_version: str = req_data.get("icat_version", "")
        authn_db_version: str = req_data.get("authn_db_version", "")

        if not icat_version or not authn_db_version:
            return Response("icat_version and authn_db_version are required", status=400)

        instance_identifier: str = random_identifier_generator()
        provision_new_icat_databases(config, instance_identifier, init_database, icat_version, authn_db_version)

        ret: dict = {
            "identifier": instance_identifier
        }

        return Response(json.dumps(ret), status=200, content_type="application/json")
    except Exception as e:
        return Response(str(e), status=500)
