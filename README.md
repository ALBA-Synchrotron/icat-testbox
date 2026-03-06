# ICAT‑testbox: Auto‑provisioned ICAT servers for unit and integration testing

The ICAT project provides a metadata catalogue and related components to support experimental data management for
large-scale facilities, linking all aspects of the research lifecycle from proposal through to data and articles
publication.

More information on ICAT can be found [here](https://icatproject.org/).
<p align="center">
<img src="https://public.cells.es/cdn/public/icat/icat-logo.png" alt="icat collaboration logo" width="200">
</p>

## Introduction

ICAT-testbox provides auto-provisioned ICAT servers on-demand, useful for unit and integration testing of components or
other projects that need to interact with an ICAT instance. Instances can be created easily with a single HTTP request,
with the option to specify specific versions for the server and authentication components, and the option to preload a
set of test fixtures onto the database.

Request:

```console
curl -X POST http://localhost:5000/testbox \
-H "Content-Type: application/json" \
-d '{
"icat_version": "6.2.0",
"authn_db_version": "3.0.0",
"init_database": true
}'
```

Response:

```console
{
  "provisioner": "icat_testbox_0", 
  "type": "icat-testbox",
  "identifier": "u20u151", 
  "creation_date": "02-03-2026 13:00:18", 
  "icat_version": "6.2.0", 
  "authn_db_version": "3.0.0", 
  "host_port": "50000", 
  "container_id": "ac6e036a3b245f6f7fd00f399488c3f92325150e6bde0244d036967c4ce45c51", 
  "container_name": "icat-test-box_u20u151"
}
```

## Prerequisites

- Docker.

## Installing

### Build base Payara image

```console
git clone https://github.com/ALBA-Synchrotron/icat-testbox.git
cd icat-testbox
docker build -t icat-testbox-payara6:latest -f ./icat-dockerfiles/payara6/Dockerfile_payara6 ./icat-dockerfiles/payara6/
```

### Deploy

```console
docker run -p 5000:5000 -d --name icat-testbox -it -v /var/run/docker.sock:/var/run/docker.sock icat-testbox:latest
```

Or mounting the fixtures directory and config file:

```console
docker run -p 5000:5000 -d --name icat-testbox -it -v /var/run/docker.sock:/var/run/docker.sock -v ./config.json:/app/config.json -v ./fixtures/:/app/fixtures/ icat-testbox:latest
```

## Usage

The project consists of a simple API built with Flask. Upon starting the application, a mariadb instance (if not
configured differently) will spin up which will be used as the database for the provisioned ICAT instances.

Instances can be created through a POST request to `/testbox` endpoint. In the request's body, both icat.server and
authn.server versions can be specified, as well as the option to preload a set of test fixtures onto the database. The
creation call also creates specific database schemas for the ICAT server and db authentication components.

```console
curl -X POST http://localhost:5000/testbox \
-H "Content-Type: application/json" \
-d '{
"icat_version": "6.2.0",
"authn_db_version": "3.0.0",
"init_database": true
}'
```

A list of the currently running icat-testbox instances can be retrieved through a GET request to `/testbox` endpoint.

```console
curl -X GET http://localhost:5000/testbox
```

An instance can be reused through a POST request to `/testbox/<instance_identifier>` endpoint. The instance's databases
are reloaded with the initial fixtures so that the testbox can be used without the overhead of re-provisioning a new
one.

```console
curl -X GET http://localhost:5000/testbox/vje9d6o
```

A specific instance can be deleted through a DELETE request to `/testbox/<instance_identifier>` endpoint. The instance
deletion also deletes the instance's corresponding database schemas.

```console
curl -X GET http://localhost:5000/testbox/vje9d6o
```

By default, the ephemeral instances have a lifespan of 180 minutes, after which they will be automatically deleted along
their database schemas. This behavior can be changed by setting the `MAX_INSTANCE_LIFETIME` environment variable or by
completely disabling the scheduler by setting `SCHEDULER_ENABLED` to `false`.

There is also the possibility to require an access token in the 'Authorization' header for all requests,
this token can be set in the `ACCESS_TOKEN` environment variable.

> **Notice**: This project is meant to be used for development and testing purposes only, an as-is production deployment
> is not recommended.

## Configuration and installation details

### Configuration file

Configuration parameters related to the database used by the application, Payara image to use, and the fixtures to
preload can be set in a `config.json` file. An example of this file can be found in the `config.json.example` file.

### Environment variables

| Name                            | Description                                                         | Default value          |
|---------------------------------|---------------------------------------------------------------------|------------------------|
| ``ICAT_TESTBOX_INSTANCE_NAME `` | Testbox provisioner name.                                           | `icat_testbox_0`       |
| ``CONFIG_FILE_PATH``            | Location of config.json file.                                       | `/app/config.json`     |
| ``DATABASE_PORT``               | Port for the auto-provisioned MariaDB.                              | `33306`                |
| ``HOST_DB_NAME``                | Name of the DB host that ICAT will connect to (only if external).   | `host.docker.internal` |
| ``DEFAULT_DATABASE``            | Database by default for the instances.                              | `mariadb`              |
| ``DOCKER_SOCKET_PATH``          | Docker's socket path.                                               | `/var/run/docker.sock` |
| ``CONTAINERS_PORT_RANGE``       | Range of ports than can be used for the provisioned ICAT instances. | `50000-55000`          |
| ``ACCESS_TOKEN``                | If set, require same token in 'Authorization' header.               |                        |
| ``SCHEDULER_ENABLED``           | Toggle scheduler.                                                   | `true`                 |
| ``SCHEDULER_CLEAN_TIMER``       | Instance lifetime expiration cron frequency in minutes.             | `30`                   |
| ``MAX_INSTANCE_LIFETIME``       | Max instance lifetime in minutes.                                   | `180`                  |
| ``LOG_LEVEL``                   | Log level for the app.                                              | `INFO`                 |

## Tests

Unit and integration tests are available in the `tests` directory. To run them, execute the following command:

```
pytest .
```

## License

Copyright (C) 2026 ALBA Synchrotron

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not,
see <https://www.gnu.org/licenses/>.