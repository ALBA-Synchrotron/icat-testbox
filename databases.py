import io
import logging
import os.path
import sys
import tarfile
from tarfile import ReadError

from docker import DockerClient
from docker.errors import APIError, NotFound
from docker.models.containers import Container

from config import Config

logger: logging.Logger = logging.getLogger(__name__)


def get_db_names(identifier: str) -> tuple[str, str]:
    icat_server_schema_name: str = f"icat_server_{identifier}"
    icat_authn_db_schema_name: str = f"icat_authn_db_{identifier}"
    return icat_server_schema_name, icat_authn_db_schema_name


def provision_new_icat_databases(config: Config, identifier: str, init_database: bool, icat_version: str,
                                 authn_db_version: str) -> tuple[str, str] | None:
    icat_server_schema_name, icat_authn_db_schema_name = get_db_names(identifier)
    dbs_to_create: list = [icat_server_schema_name, icat_authn_db_schema_name]

    db_provision_commands: list = create_db_schema_commands(config.default_database, dbs_to_create)

    dc: DockerClient = config.get_docker_client()

    try:
        db_container: Container = dc.containers.get(f"{config.icat_testbox_instance_name}_db")
        exit_code, _ = db_container.exec_run(db_provision_commands)
        if exit_code != 0:
            raise Exception(f"Database provisioning failed with exit code {exit_code}")

        logger.info(f"Databases provisioned successfully, db_names are {dbs_to_create}")
        if init_database:
            logger.info("Initializing database with basic data...")
            server_fixtures_file = config.get_fixtures_file("icat_server", icat_version)
            authn_fixtures_file = config.get_fixtures_file("authn_db", authn_db_version)

            logger.info(f"Loading server db data from {server_fixtures_file}")
            load_db_fixtures(config, db_container, server_fixtures_file, icat_server_schema_name)

            logger.info(f"Loading authn db data from {authn_fixtures_file}")
            load_db_fixtures(config, db_container, authn_fixtures_file, icat_authn_db_schema_name)
        return icat_server_schema_name, icat_authn_db_schema_name
    except NotFound as e:
        sys.exit(f"Database container not found: {e}")
    except APIError as e:
        logger.error(f"Error provisioning database: {e}")


def load_db_fixtures(config: Config, db_container: Container, fixtures_file_path: str, db_schema: str) -> None:
    if not fixtures_file_path:
        return
    commands: list = []

    data = None
    try:
        with open(os.path.join(os.getcwd(), "fixtures", fixtures_file_path), "rb") as f:
            data = f.read()

        tar_stream = io.BytesIO()
        with tarfile.open(fileobj=tar_stream, mode="w") as tar:
            tarinfo = tarfile.TarInfo(name=f"fixtures_{db_schema}.sql")  # The filename inside the container
            tarinfo.size = len(data)
            tar.addfile(tarinfo, io.BytesIO(data))
        tar_stream.seek(0)

        fixtures_copied: bool = db_container.put_archive(f"/tmp", tar_stream)

        if fixtures_copied:
            match config.default_database:
                case "mariadb":
                    commands = ["mariadb", db_schema, "-e", f"source /tmp/fixtures_{db_schema}.sql"]
                case _:
                    raise ValueError("Invalid database type")

        _, __ = db_container.exec_run(commands)

        failed, _ = db_container.exec_run(["rm", f"/tmp/fixtures_{db_schema}.sql"])
        if failed:
            raise Exception(f"Failed to remove fixtures file from container")
    except (OSError, ReadError) as exc:
        raise RuntimeError(f"Failed to load fixtures into database: {exc}")


def drop_icat_databases(config: Config, identifier: str) -> None:
    icat_server_schema_name, icat_authn_db_schema_name = get_db_names(identifier)

    dbs_to_drop: list = [icat_server_schema_name, icat_authn_db_schema_name]
    db_drop_commands: list = drop_db_schema_commands(config.default_database, dbs_to_drop)

    dc: DockerClient = config.get_docker_client()
    try:
        db_container: Container = dc.containers.get(f"{config.icat_testbox_instance_name}_db")
        exit_code, _ = db_container.exec_run(db_drop_commands)
        if exit_code != 0:
            raise Exception(f"Database dropping failed with exit code {exit_code}")
    except (APIError, NotFound) as exc:
        raise RuntimeError(f"Failed to drop ICAT databases: {exc}")


def create_db_schema_commands(db_type: str, db_names: list) -> list:
    match db_type:
        case "mariadb":
            return [
                "mariadb", "-e", " ".join(
                    f"CREATE DATABASE {db_name} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
                    for db_name in db_names
                ),
            ]
        case _:
            raise ValueError("Invalid database type")


def db_user_permissions_commands(db_type: str, username: str, password: str) -> list:
    match db_type:
        case "mariadb":
            return [
                "mariadb", "-e",
                f"CREATE USER '{username}'@'%' IDENTIFIED BY '{password}'; GRANT ALL PRIVILEGES ON *.* TO '{username}'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
            ]
        case _:
            raise ValueError("Invalid database type")


def drop_db_schema_commands(db_type: str, db_names: list) -> list:
    match db_type:
        case "mariadb":
            return [
                "mariadb", "-e", " ".join(
                    f"DROP DATABASE {db_name};"
                    for db_name in db_names
                ),
            ]
        case _:
            raise ValueError("Invalid database type")
