#!/usr/bin/env bash

# Update package repositories
apt-get update

# Install and configure Apache
apt-get install -y apache2
a2enmod rewrite
mkdir -p /vagrant/logs
ln -fs /vagrant/config/001-acc.conf /etc/apache2/sites-available/001-acc.conf
sed -i 's/www-data/vagrant/' /etc/apache2/envvars

# Install MySQL and set root password to "vagrant"
debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'
apt-get install -y mysql-server
ln -fs /vagrant/config/.my.cnf /home/vagrant/.my.cnf

# Install PHP and needed modules, do more Apache configuration, then restart Apache
apt-get install -y php5 php5-mysql php5-curl php5-mcrypt
php5enmod mcrypt
a2dissite 000-default
a2ensite 001-acc
service apache2 restart

# Install Git
apt-get install -y git

# Get ACC files from Git
if [[ ! -e /vagrant/html/waca ]]; then
	git clone https://github.com/enwikipedia-acc/waca /vagrant/html/waca
	ln -fs ../../config/config.local.inc.php /vagrant/html/waca/config.local.inc.php
fi
cd /vagrant/html/waca
git submodule update --init

# Create database, populate message/template tables, apply patches, and create admin user
export MYSQL_PWD='vagrant'
if ! mysql -e 'USE acc;'; then
	cd /vagrant/html/waca/sql
	mysql -e "CREATE DATABASE acc;"
	mysql acc < db-structure.sql
	mysql acc < email-template-data.sql
	for p in patches/*.sql; do
		if [[ -e $p ]]; then
			mysql acc < $p
		fi
	done
	mysql acc -e "INSERT INTO user (username, email, password, status, onwikiname, checkuser) VALUES ('Admin', 'vagrant@localhost', '63623900c8bbf21c706c45dcb7a2c083', 'Admin', 'Admin', '1');"
fi
