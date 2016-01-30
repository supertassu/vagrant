acc-vagrant
===========

Vagrant environment for ACC

# Installation

1. Install [VirtualBox] (https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant] (http://www.vagrantup.com/downloads.html)
3. Install Git
4. Clone this repository
5. Run "vagrant up" in a shell prompt


# Documentation
Once "vagrant up" finishes running, you can open up http://127.0.0.1:8081/waca/acc.php and log in using "Admin" and "vagrant" as the username and password. This account should have Tool Administrator and CheckUser set on it.

In addition, there are "AdminNoCU", "CheckUser", "User", and "New" users with the same password.

If you want to run commands on the virtual machine that Vagrant creates (such as "sudo apt-get update; sudo apt-get upgrade"), you can run "vagrant ssh" while in this directory. 

The config directory contains the config.local.inc.php file that ACC uses and the VirtualHost file that Apache uses.

If you need the MySQL login details, the username is "root" and the password is "vagrant". This is a virtual machine that is only intended for development purposes so security isn't particularly important here.

There is a phpinfo() file at http://127.0.0.1:8081/info.php.

cleanup.sh/cleanup.bat is a small shell script that destroys the Vagrant environment, deletes the logs directory, and deletes the html/waca directory.
