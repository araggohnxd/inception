#!/bin/sh

# Set shell script directives:
# - e: exit with non-zero value if any command inside script fails
# - x: output each and every command to stdout
set -xe

# Initializes the MariaDB data directory and creates the system tables that it contains.
# This step is necessary for the creation and setup of /var/lib/mysql,
# a directory that the MySQL dameon will need to access later on.
mysql_install_db

# Initializes MySQL dameon
/etc/init.d/mysql start

# If database isn't already configured
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
    # Run MariaDB secure installation script
    # This script allows you to improve the security of your MariaDB installation by letting you:
    # - Set a password for root accounts;
    # - Remove root accounts that are accessible from outside the local host;
    # - Remove anonymous-user accounts;
    # - Remove the test database, which by default can be accessed by anonymous users.
    # Here, a here-document is used to communicate with the script and appropriately answer the prompts.
    mysql_secure_installation << __EOF

y
$DB_ROOT_PASS
$DB_ROOT_PASS
y
y
y
y
__EOF

    # Creates a new database with the name specified in the .env file, if it doesn't already exists
    mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

    # Grants all privileges on all databases and tables to the root user, and set it's password
    mysql -e "GRANT ALL ON *.* TO '$DB_ROOT_USER'@'%' IDENTIFIED BY '$DB_ROOT_PASS';"
    
    # Grants all privileges on WordPress' database to the common user, and set it's password
    mysql -e "GRANT ALL ON $DB_NAME.* TO '$DB_USER_USER'@'%' IDENTIFIED BY '$DB_USER_PASS';"
    
    # Flush privileges is used to update MariaDB's privilege table with the newly made changes
    mysql -e "FLUSH PRIVILEGES;"

    # Imports the database backup from the dump file, generated previously with all configurations already set
    mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS $DB_NAME < /tmp/dump.sql
fi

# Terminates MySQL daemon
# This step is more of a good practice, the daemon will be started again in the exec line, anyways.
/etc/init.d/mysql stop

# Execute any commands given to the container
# Defaults to command present in Dockerfile:
# mysqld --bind-address=0.0.0.0
exec "$@"
