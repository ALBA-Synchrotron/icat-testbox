import datetime
import logging
import os
import secrets
import string

from apscheduler.schedulers.background import BackgroundScheduler
from docker import DockerClient
from docker.errors import APIError, NotFound

from config import Config
from containers import provision_database_container, get_current_icat_testboxes, delete_icat_testbox
from databases import db_user_permissions_commands

logger: logging.Logger = logging.getLogger(__name__)


def before_start(config: Config) -> None:
    logging.basicConfig(
        level=logging.getLevelName(config.log_level),
        format="%(asctime)s %(levelname)s [%(name)s] %(message)s",
        force=True,
    )

    logger.info("Starting server...")
    dc: DockerClient = config.get_docker_client()

    try:
        db_container = dc.containers.get(f"{config.icat_testbox_instance_name}_db")
        logger.info(f"Database container status: {db_container.status}")
        if db_container.status != "running":
            logger.info("Database container is not running. Starting database container...")
            db_container.start()
    except NotFound:
        logger.error("Database container not found. Provisioning new database container...")
        db_container = provision_database_container(config)
        db_username, db_password = config.get_default_db_credentials()
        db_perm_commands: list = db_user_permissions_commands(config.default_database, db_username, db_password)
        ret, _ = db_container.exec_run(db_perm_commands)

        logger.info(f"Database container status: {db_container.status}")

    except APIError as e:
        raise RuntimeError(f"Error interacting with Docker API: {e}")


def random_identifier_generator(length: int = 7) -> str:
    alphabet: str = string.ascii_lowercase + string.digits
    return "".join(secrets.choice(alphabet) for _ in range(length))


def clear_expired_testboxes(config: Config) -> None:
    containers: list = get_current_icat_testboxes(config)
    current_time: datetime.datetime = datetime.datetime.now()
    for i in containers:
        created_at: str = i.labels.get("creation_date", None)
        identifier: str = i.labels.get("identifier", None)

        if created_at and identifier:
            created_at: datetime.datetime = datetime.datetime.strptime(created_at, "%d-%m-%Y %H:%M:%S")
            if created_at + datetime.timedelta(minutes=config.max_instance_lifetime) > current_time:
                delete_icat_testbox(config, identifier)
                logger.info(f"Deleted expired testbox {identifier}")


def init_scheduler(config: Config) -> BackgroundScheduler | None:
    ret = None
    if config.scheduler_enabled and "PYTEST_CURRENT_TEST" not in os.environ:
        ret = BackgroundScheduler()
        ret.add_job(clear_expired_testboxes, 'interval', seconds=10, kwargs={"config": config})
        ret.start()
    return ret
