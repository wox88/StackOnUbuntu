#! /bin/bash
KEYSTONE_DBNAME=keystone
KEYSTONE_DBPASS=xiandao2015
MYSQL_HOST=127.0.0.1
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

SCRIPT_PATH=./
function config_keystone {
	sudo cp $SCRIPT_PATH/keystone.conf /etc/keystone/keystone.conf
}

function keystone_dbsync {
	sudo keystone-manage db_sync
}

function config_mod-wsgi_keystone {
	sudo cp $SCRIPT_PATH/wsgi-keystone.conf.template /etc/apache2/sites-available/wsgi-keystone.conf
	sudo ln -s /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-enabled
	sudo mkdir -p /var/www/cgi-bin/keystone
	sudo cp $SCRIPT_PATH/keystone-wsgi-admin /var/www/cgi-bin/keystone/admin
	sudo cp $SCRIPT_PATH/keystone-wsgi-main /var/www/cgi-bin/keystone/main
	sudo chown -R keystone:keystone /var/www/cgi-bin/keystone
	sudo chmod 755 /var/www/cgi-bin/keystone/*

	sudo service apache2 restart
}
