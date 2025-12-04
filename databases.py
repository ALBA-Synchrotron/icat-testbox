import io
import os.path
import tarfile

from docker.models.containers import Container

from config import Config


def provision_new_icat_database(config: Config, identifier: str, icat_version: str, load_fixtures: bool) -> None:
    db_provision_commands, db_schema_name = create_db_schema_commands(config, identifier)
    dc = config.get_docker_client()
    db_container = dc.containers.get(f"{config.icat_testbox_instance_name}_db")

    try:
        db_container.exec_run(db_provision_commands)
        print(f"Database provisioned successfully, db_name = icat_{identifier}")
        if load_fixtures:
            print("Loading basic fixtures...")
            fixtures_file = config.get_fixtures_file(icat_version)
            load_db_fixtures(config, db_container, fixtures_file, db_schema_name)

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
    with tarfile.open(fileobj=tar_stream, mode='w') as tar:
        tarinfo = tarfile.TarInfo(name="fixtures.sql")  # The filename inside the container
        tarinfo.size = len(data)
        tar.addfile(tarinfo, io.BytesIO(data))

    tar_stream.seek(0)
    db_container.put_archive(f"/tmp", tar_stream)

    match config.default_database:
        case "mariadb":
            commands = ["mariadb", db_schema, "-e", "source /tmp/fixtures.sql"]
        case _:
            raise ValueError("Invalid database type")
    db_container.exec_run(commands)


def create_db_schema_commands(config: Config, identifier: str) -> list:
    db_name: str = identifier
    match config.default_database:
        case "mariadb":
            return ["mariadb", "-e",
                    f"CREATE DATABASE {db_name} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"], db_name
        case _:
            raise ValueError("Invalid database type")


def drop_db_schema_commands(config: Config, identifier: str) -> list:
    match config.default_database:
        case "mariadb":
            return ["mariadb", "-e", f"DROP DATABASE icat_{identifier};"]
        case _:
            raise ValueError("Invalid database type")
