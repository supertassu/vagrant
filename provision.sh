#!/usr/bin/env bash

# Update package repositories
apt-get update

# Remove unneeded stuff
apt-get autoremove -y

# Install htop
apt-get install -y htop

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
apt-get install -y php5 php5-mysql php5-curl php5-mcrypt php5-xdebug
php5enmod mcrypt
php5enmod xdebug
rm /etc/php5/apache2/php.ini
ln -fs /vagrant/config/php.ini /etc/php5/apache2/php.ini
a2dissite 000-default
a2ensite 001-acc
service apache2 restart

# Install Git
apt-get install -y git

# Get ACC files from Git
if [[ ! -e /vagrant/html/waca ]]; then
	git clone https://github.com/enwikipedia-acc/waca /vagrant/html/waca
	echo $'<?php\nrequire_once("/vagrant/config/config.local.inc.php");\n' > /vagrant/html/waca/config.local.inc.php
fi
cd /vagrant/html/waca
git submodule update --init

# Create database, populate message/template tables, apply patches, and create admin user
# Note that database creation will only be done if no database named `acc` exists - if you wish to recreate the database
# by rerunning this provisioner, please first drop the acc database.
export MYSQL_PWD='vagrant'
if ! mysql -e 'USE acc;'; then
	echo "You can safely ignore the above database error."
	cd /vagrant/html/waca/sql
	./test_db.sh 1 localhost acc root vagrant
	mysql acc < /vagrant/data.sql
fi
echo "Provisioning complete!"
