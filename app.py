import json
from json import JSONDecodeError

from flask import Flask, Response, request

from auth import require_token
from config import Config
from containers import provision_new_icat_testbox, get_current_icat_testboxes, delete_icat_testbox
from databases import provision_new_icat_databases
from utils import before_start, random_identifier_generator

config: Config = Config()
before_start(config)
app: Flask = Flask(__name__)


@app.route("/", methods=["GET"])
def hello_world() -> Response:
    return Response("<p>Hello, World!</p>", status=200)


@app.route("/testbox", methods=["POST"])
@require_token(config)
def provision_icat_testbox_instance() -> Response:
    try:
        req_data: dict = json.loads(request.data.decode())
        init_database: bool = req_data.get("load_fixtures", True)
        icat_version: str = req_data.get("icat_version", "")
        authn_db_version: str = req_data.get("authn_db_version", "")

        if not icat_version or not authn_db_version:
            return Response("icat_version and authn_db_version are required", status=400)

        instance_identifier: str = random_identifier_generator()
        icat_server_schema_name, icat_authn_db_schema_name = provision_new_icat_databases(config, instance_identifier,
                                                                                          init_database, icat_version,
                                                                                          authn_db_version)
        ret: dict = provision_new_icat_testbox(config, instance_identifier, icat_version, authn_db_version,
                                               icat_server_schema_name,
                                               icat_authn_db_schema_name)
        return Response(json.dumps(ret), status=200, content_type="application/json")
    except JSONDecodeError as e:
        return Response(str(e), status=400)


@app.route("/testbox", methods=["GET"])
@require_token(config)
def list_icat_testboxes() -> Response:
    containers: list = get_current_icat_testboxes(config)
    ret: list = [{**i.labels, "status": i.status, "container_id": i.id, "container_name": i.name} for i in containers]
    return Response(json.dumps(ret), status=200, content_type="application/json")


@app.route("/testbox/<identifier>", methods=["DELETE"])
@require_token(config)
def delete_testbox(identifier: str) -> Response:
    deleted: bool = delete_icat_testbox(config, identifier)
    if not deleted:
        return Response("Testbox not found", status=404)
    return Response(json.dumps({"msg": f"Testbox {identifier} deleted successfully"}), status=200, content_type="application/json")
