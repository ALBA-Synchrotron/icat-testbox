jar_client=$DB_JAR_CLIENT
icat_server_version=$ICAT_SERVER_VERSION
icat_authn_db_version=$ICAT_AUTHN_DB_VERSION
db_type=$DB_TYPE
db_server=$DB_HOSTNAME
db_host_port=$DB_HOST_PORT
db_user=$DB_USER
db_password=$DB_PASSWORD
icat_server_db_schema=$ICAT_SERVER_DB_SCHEMA_NAME
icat_authn_db_schema=$ICAT_AUTHN_DB_SCHEMA_NAME

export POSTBOOT_COMMANDS=/opt/payara/deployments/post_boot_asadmin_commands

touch /opt/payara/glassfish-acc.xml
touch /opt/payara/deployments/glassfish-acc.xml
touch /opt/payara/appserver/glassfish-acc.xml

mkdir -p /opt/payara/libs/

curl -o /opt/payara/libs/mariadb-java-client.jar $jar_client

curl -o /opt/payara/deployments/01_icat.server.war https://repo.icatproject.org/repo/org/icatproject/icat.server/${icat_server_version}/icat.server-${icat_server_version}.war
curl -o /opt/payara/deployments/00_authn.db.war https://repo.icatproject.org/repo/org/icatproject/authn.db/${icat_authn_db_version}/authn.db-${icat_authn_db_version}.war

cat > /tmp/icat_server_run.properties << 'EOF'
lifetimeMinutes = 120
rootUserNames = root db/root
maxEntities = 30000
maxIdsInQuery = 500
importCacheSize = 50
exportCacheSize = 50
authn.list = db
authn.db.url = http://localhost:8080
notification.list = Dataset Datafile
notification.Dataset = CU
notification.Datafile = CU
log.list = SESSION WRITE READ INFO
!jms.topicConnectionFactory = jms/CustomConnectionFactory
!search.engine =
EOF

cd /opt/payara/deployments \
 && mkdir -p tmpwar/WEB-INF/classes \
 && cd tmpwar \
 && jar xf ../00_authn.db.war \
 && sed -i 's/<transport-guarantee>CONFIDENTIAL<\/transport-guarantee>/<transport-guarantee>NONE<\/transport-guarantee>/g' WEB-INF/web.xml \
 && jar cf ../00_authn.db.war . \
 && cd .. \
 && rm -rf tmpwar

cd /opt/payara/deployments \
 && mkdir -p tmpwar/WEB-INF/classes \
 && cd tmpwar \
 && jar xf ../01_icat.server.war \
 && cp /tmp/icat_server_run.properties WEB-INF/classes/run.properties \
 && sed -i 's/<transport-guarantee>CONFIDENTIAL<\/transport-guarantee>/<transport-guarantee>NONE<\/transport-guarantee>/g' WEB-INF/web.xml \
 && jar cf ../01_icat.server.war . \
 && cd .. \
 && rm -rf tmpwar


echo 'add-library --type app /opt/payara/libs/mariadb-java-client.jar' >> /opt/payara/deployments/post_boot_asadmin_commands

echo 'create-jms-resource --restype jakarta.jms.Topic jms/ICAT/Topic' >> /opt/payara/deployments/post_boot_asadmin_commands
echo 'create-jms-resource --restype jakarta.jms.Topic jms/ICAT/log' >> /opt/payara/deployments/post_boot_asadmin_commands

# First pool: icat DB
PROPS_ICAT="user=${db_user}:password=${db_password}:url=\"jdbc:${db_type}:://${db_server}:${db_host_port}/${icat_server_db_schema}\""

echo "create-jdbc-connection-pool \
--datasourceclassname org.mariadb.jdbc.MariaDbDataSource \
--property ${PROPS_ICAT} \
--restype javax.sql.DataSource \
--failconnection=true \
--steadypoolsize 2 \
--maxpoolsize 32 \
--ping icat" >> /opt/payara/deployments/post_boot_asadmin_commands

echo 'create-jdbc-resource --connectionpoolid icat jdbc/icat' >> /opt/payara/deployments/post_boot_asadmin_commands


# Second pool: authn DB
PROPS_AUTHN="user=${db_user}:password=${db_password}:url=\"jdbc:${db_type}:://${db_server}:${db_host_port}/${icat_authn_db_schema}\""

echo "create-jdbc-connection-pool \
--datasourceclassname org.mariadb.jdbc.MariaDbDataSource \
--property ${PROPS_AUTHN} \
--restype javax.sql.DataSource \
--failconnection=true \
--steadypoolsize 2 \
--maxpoolsize 32 \
--ping authn_db" >> /opt/payara/deployments/post_boot_asadmin_commands

echo 'create-jdbc-resource --connectionpoolid authn_db jdbc/authn_db' >> /opt/payara/deployments/post_boot_asadmin_commands

/opt/payara/scripts/entrypoint.sh