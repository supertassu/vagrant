exec { 'apt-update':
	command => '/usr/bin/apt-get update',
}

exec { 'apt-autoremove':
	command => '/usr/bin/apt-get autoremove -y',
}

package { 'htop':
	require => Exec['apt-update'],
	ensure => installed,
}

package { 'git':
	require => Exec['apt-update'],
	ensure 
	
package { 'unattended-upgrades':
	require => Exec['apt-update'],
	ensure => installed,
}

class { 'apache':
	require => Exec['apt-update'],
	default_vhost => false,
	mpm_module => 'prefork',
}

class { 'apache::mod::rewrite': }
class { 'apache::mod::php': }

apache::vhost { 'acc': 
	port => '80',
	docroot => '/vagrant/html',
	serveradmin => 'vagrant@localhost',
	directories => [
	{	path => '/vagrant/html',
		options => ['Indexes','FollowSymLinks'],
		rewrites => [ { rewrite_rule => ['^$ /waca [L]'], } ],
	},],
	php_flags => { 
		display_errors => 'on', 
		display_startup_errors => 'on',
		html_errors => 'on',
		log_errors => 'on',
		track_errors => 'on',
		'xdebug.remote_enable' => 'on',
		'xdebug.remote_connect_back' => 'on',
	},
	php_values => { 'xdebug.max_nesting_level' => '200', },
	logroot => '/vagrant/logs',
	ip_based => true,
}

class { 'php': 
	require => Exec['apt-update'],
}

php::module { "mysql": } php::mod { "mysql": }
php::module { "curl": } php::mod { "curl": }
php::module { "mcrypt": } php::mod { "mcrypt": }
php::module { "xdebug": } php::mod { "xdebug": }

$mods = ["mysql", "curl", "mcrypt", "xdebug"]
php::mod { "$mods": }

class { '::mysql::server':
	require => Exec['apt-update'],
	root_password => 'vagrant',
	remove_default_accounts => true,
}

file { "/home/vagrant/.my.cnf":
	require => Class['::mysql::server'],
	ensure => present,
	source => '/root/.my.cnf',
	owner => 'vagrant',
}

vcsrepo { '/vagrant/html/waca':
	require => Package['git'],
	ensure => present,
	provider => git,
	source => 'https://github.com/enwikipedia-acc/waca.git',
}

file { '/vagrant/html/waca/config.local.inc.php':
	require => Vcsrepo['/vagrant/html/waca'],
	ensure => present,
	source => '/vagrant/config/.config.vagrant.inc.php',
}

file { '/vagrant/config/config.local.inc.php':
	ensure => present,
}

exec { 'createdb-1':
	require => Class['::mysql::server'],
	unless => '/usr/bin/mysql -pvagrant acc',
	cwd => '/vagrant/html/waca/sql',
	provider => 'shell',
	command => './test_db.sh 1 localhost acc root vagrant',
	notify => Exec['createdb-2'],
}

exec { 'createdb-2':
	command => '/usr/bin/mysql -pvagrant acc < /vagrant/data.sql',
	refreshonly => true,
}
