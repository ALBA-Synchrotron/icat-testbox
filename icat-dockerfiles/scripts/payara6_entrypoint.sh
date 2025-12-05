jar_client=$DB_JAR_CLIENT
icat_server_version=$ICAT_SERVER_VERSION
icat_authn_db_version=$ICAT_AUTHN_DB_VERSION
db_type=$DB_TYPE
db_server=$DB_HOSTNAME
db_host_port=$DB_HOST_PORT
icat_server_db_schema=$ICAT_SERVER_DB_SCHEMA_NAME
icat_authn_db_schema=$ICAT_AUTHN_DB_SCHEMA_NAME

export POSTBOOT_COMMANDS=/opt/payara/deployments/post_boot_asadmin_commands

touch /opt/payara/glassfish-acc.xml

mkdir -p /opt/payara/deployments/icat_server/
mkdir -p /opt/payara/deployments/authn_db/

curl -o /opt/payara/libs/mariadb-java-client.jar mariadb-java-client.jar $jar_client

curl -o /opt/payara/deployments/icat_server/icat.server.war https://repo.icatproject.org/repo/org/icatproject/icat.server/${icat_server_version}/icat.server-${icat_server_version}.war
curl -o /opt/payara/deployments/authn_db/authn.db.war https://repo.icatproject.org/repo/org/icatproject/authn.db/${icat_authn_db_version}/authn.db-${icat_authn_db_version}.war

echo 'add-library --type app /opt/payara/libs/mariadb-java-client.jar' > /opt/payara/deployments/post_boot_asadmin_commands

echo 'create-jms-resource --restype jakarta.jms.Topic jms/ICAT/Topic' > /opt/payara/deployments/post_boot_asadmin_commands
echo 'create-jms-resource --restype jakarta.jms.Topic jms/ICAT/log' > /opt/payara/deployments/post_boot_asadmin_commands

echo "create-jdbc-connection-pool \
--datasourceclassname org.mariadb.jdbc.MariaDbDataSource \
--property user=${db_user}:password=${db_password}:url=\"jdbc:${db_type}://${db_server}:${db_host_port}/${icat_server_db_schema}\" \
--restype javax.sql.DataSource \
--failconnection=true \
--steadypoolsize 2 \
--maxpoolsize 32 \
--ping icat" > /opt/payara/deployments/post_boot_asadmin_commands
echo 'create-jdbc-resource --connectionpoolid icat jdbc/icat' > /opt/payara/deployments/post_boot_asadmin_commands

echo "create-jdbc-connection-pool \
--datasourceclassname org.mariadb.jdbc.MariaDbDataSource \
--property user=${db_user}:password=${db_password}:url=\"jdbc:${db_type}://${db_server}:${db_host_port}/${icat_authn_db_schema}\" \
--restype javax.sql.DataSource \
--failconnection=true \
--steadypoolsize 2 \
--maxpoolsize 32 \
--ping authn_db" > /opt/payara/deployments/post_boot_asadmin_commands
echo 'create-jdbc-resource --connectionpoolid authn_db jdbc/authn_db' > /opt/payara/deployments/post_boot_asadmin_commands

/opt/payara/scripts/entrypoint.sh