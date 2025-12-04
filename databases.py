import io
import os.path
import tarfile

from docker.models.containers import Container

from config import Config


def provision_new_icat_databases(config: Config, identifier: str, init_database: bool, icat_version: str,
                                 authn_db_version: str) -> None:
    icat_server_schema_name: str = f"icat_server_{identifier}"
    icat_authn_db_schema_name: str = f"icat_authn_db_{identifier}"
    dbs_to_create: list = [icat_server_schema_name, icat_authn_db_schema_name]

    db_provision_commands: list = create_db_schema_commands(config.default_database, dbs_to_create)

    dc = config.get_docker_client()
    db_container = dc.containers.get(f"{config.icat_testbox_instance_name}_db")

    try:
        db_container.exec_run(db_provision_commands)
        print(f"Databases provisioned successfully, db_names are {dbs_to_create}")
        if init_database:
            print("Initializing database with basic data...")
            server_fixtures_file = config.get_fixtures_file("icat_server", icat_version)
            authn_fixtures_file = config.get_fixtures_file("authn_db", authn_db_version)

            print(f"Loading server db data from {server_fixtures_file}")
            load_db_fixtures(config, db_container, server_fixtures_file, icat_server_schema_name)

            print(f"Loading authn db data from {authn_fixtures_file}")
            load_db_fixtures(config, db_container, authn_fixtures_file, icat_authn_db_schema_name)

    except Exception as e:
        print(f"Error provisioning database: {e}")


def load_db_fixtures(config: Config, db_container: Container, fixtures_file_path: str, db_schema: str) -> None:
    if not fixtures_file_path:
        return
    commands: list = []

    data = None
    with open(os.path.join(os.getcwd(), "fixtures", fixtures_file_path), "rb") as f:
        data = f.read()

    tar_stream = io.BytesIO()
    with tarfile.open(fileobj=tar_stream, mode="w") as tar:
        tarinfo = tarfile.TarInfo(name=f"fixtures_{db_schema}.sql")  # The filename inside the container
        tarinfo.size = len(data)
        tar.addfile(tarinfo, io.BytesIO(data))

    tar_stream.seek(0)
    db_container.put_archive(f"/tmp", tar_stream)

    match config.default_database:
        case "mariadb":
            commands = ["mariadb", db_schema, "-e", f"source /tmp/fixtures_{db_schema}.sql"]
        case _:
            raise ValueError("Invalid database type")
    db_container.exec_run(commands)
    db_container.exec_run(["rm", f"/tmp/fixtures_{db_schema}.sql"])


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
