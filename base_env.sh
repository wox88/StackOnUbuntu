#!/bin/bash

MYSQL_HOST=127.0.0.1
MYSQL_USER=root
MYSQL_PASSWORD=xiandao2015
MYSQL_CONN=mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_HOST

function install_mysql {
	#install mysql in silent
	sudo debconf-set-selections <<MYSQL_PRESEED
mysql-server mysql-server/root_password password $MYSQL_PASSWORD
mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD
mysql-server mysql-server/start_on_boot boolean true
MYSQL_PRESEED

	sudo DEBIAN_FRONTEND=noninteractive apt-get --option Dpkg::Options::=--force-confold --assume-yes install mysql-server

	# Set Privileges of root
	sudo mysql -uroot -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by '$MYSQL_PASSWORD ' WITH GRANT OPTION; FLUSH PRIVILEGES;"
	sudo mysql -uroot -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO '
root'@'localhost' identified by '$MYSQL_PASSWORD ' WITH GRANT OPTION; FLUSH PRIVILEGES;"
}

RABBITMQ_HOST=127.0.0.1
RABBITMQ_USER=openstack
RABBITMQ_PASSWORD=xiandao2015

function install_rabbit {
	# Install rabbitmq server
	sudo apt-get install -y rabbitmq-server

	# Add the openstack user
	sudo rabbitmqctl add_user $RABBITMQ_USER $RABBITMQ_PASSWORD
	
	# Set privileges of openstack
	sudo rabbitmqctl set_permissions $RABBITMQ_USER ".*" ".*" ".*"
}

install_mysql
install_rabbit
