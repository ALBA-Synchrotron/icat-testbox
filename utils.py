import secrets
import string

import docker

from config import Config
from containers import provision_database_container
from databases import db_user_permissions_commands


def before_start(config: Config) -> None:
    print("Starting server...")
    dc = config.get_docker_client()

    db_container = None
    try:
        db_container = dc.containers.get(f"{config.icat_testbox_instance_name}_db")
        print(f"Database container status: {db_container.status}")
        if db_container.status != "running":
            print("Database container is not running. Starting database container...")
            db_container.start()
    except docker.errors.NotFound:
        print("Database container not found. Provisioning new database container...")
        db_container = provision_database_container(config)
        db_username, db_password = config.get_default_db_credentials()
        db_perm_commands: list = db_user_permissions_commands(config.default_database, db_username, db_password)
        db_container.exec_run(db_perm_commands)

        print(f"Database container status: {db_container.status}")


def random_identifier_generator(length: int = 7) -> str:
    alphabet = string.ascii_lowercase + string.digits
    return "".join(secrets.choice(alphabet) for _ in range(length))
