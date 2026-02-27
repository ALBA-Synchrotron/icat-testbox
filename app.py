import json
import logging
from json import JSONDecodeError

from flask import Flask, Response, request, Blueprint

import messages as msg
from auth import require_token
from config import Config
from containers import provision_new_icat_testbox, get_current_icat_testboxes, delete_icat_testbox
from databases import provision_new_icat_databases
from utils import before_start, random_identifier_generator, init_scheduler

bp = Blueprint('app', __name__)

config: Config = Config()
before_start(config)
scheduler = init_scheduler(config)


@bp.route("/", methods=["GET"])
def hello_world() -> Response:
    ret: dict = {"msg": msg.STATUS_OK}
    return Response(json.dumps(ret), status=200, content_type="application/json")


@bp.route("/testbox", methods=["POST"])
@require_token(config)
def create_testbox() -> Response:
    try:
        if not request.data:
            return Response(json.dumps({"msg": msg.ERR_INVALID_PAYLOAD}), status=400, content_type="application/json")
        req_data: dict = json.loads(request.data.decode())
        init_database: bool = req_data.get("load_fixtures", True)
        icat_version: str = req_data.get("icat_version", "")
        authn_db_version: str = req_data.get("authn_db_version", "")

        if not icat_version or not authn_db_version:
            return Response(json.dumps({"msg": msg.ERR_MISSING_VERSIONS}), status=400, content_type="application/json")

        if init_database and not config.component_versions_supported(
                {"icat_server": icat_version, "authn_db": authn_db_version}):
            return Response(json.dumps({"msg": msg.ERR_INVALID_VERSIONS}), status=400, content_type="application/json")

        instance_identifier: str = random_identifier_generator()
        icat_server_schema_name, icat_authn_db_schema_name = provision_new_icat_databases(config,
                                                                                          instance_identifier,
                                                                                          init_database,
                                                                                          icat_version,
                                                                                          authn_db_version)
        ret: dict = provision_new_icat_testbox(config, instance_identifier, icat_version, authn_db_version,
                                               icat_server_schema_name,
                                               icat_authn_db_schema_name)
        return Response(json.dumps(ret), status=200, content_type="application/json")
    except JSONDecodeError as e:
        return Response(str(e), status=400)


@bp.route("/testbox", methods=["GET"])
@require_token(config)
def list_testboxes() -> Response:
    containers: list = get_current_icat_testboxes(config)
    ret: list = [{**i.labels, "status": i.status, "container_id": i.id, "container_name": i.name} for i in containers]
    return Response(json.dumps(ret), status=200, content_type="application/json")


@bp.route("/testbox/<identifier>", methods=["DELETE"])
@require_token(config)
def delete_testbox(identifier: str) -> Response:
    deleted: bool = delete_icat_testbox(config, identifier)
    if not deleted:
        return Response(json.dumps({"msg": msg.ERR_NOT_FOUND}), status=404, content_type="application/json")
    return Response(json.dumps({"msg": msg.TESTBOX_DELETED}), status=200, content_type="application/json")


def create_app() -> Flask:
    flask_app: Flask = Flask(__name__)
    flask_app.register_blueprint(bp)

    flask_app.logger.debug("DEBUG visible?")
    logging.getLogger(__name__).debug("ROOT visible?")
    return flask_app


if __name__ == "__main__":
    app = create_app()
