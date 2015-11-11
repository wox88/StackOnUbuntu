#! /bin/bash
KEYSTONE_DBNAME=keystone
KEYSTONE_DBPASS=xiandao2015

function mysql_cmd() {
	mysql -uroot -p$MYSQL_PASSWORD -h$MYSQL_HOST -e "$@"
}

function mysql_add_keystone {
	mysql_cmd "CREATE DATABASE $KEYSTONE_DBNAME;"
	mysql_cmd "GRANT ALL PRIVILEGES ON $KEYSTONE_DBNAME.* TO '$KEYSTONE_DBNAME'@'localhost' IDENTIFIED BY '$KEYSTONE_DBPASS';"
	mysql_cmd "GRANT ALL PRIVILEGES ON $KEYSTONE_DBNAME.* TO '$KEYSTONE_DBNAME'@'%' IDENTIFIED BY '$KEYSTONE_DBPASS';"
	mysql_cmd "FLUSH PRIVILEGES;"
}

function install_keystone {
	echo "manual" | sudo tee /etc/init/keystone.override
	sudo apt-get install -y python-mysqldb memcached python-memcache keystone apache2 libapache2-mod-wsgi python-openstackclient
}
