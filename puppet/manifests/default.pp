class { 'apt':
  update => {
	frequency => 'always',
  },
}

file { '/vagrant/html':
	ensure => directory,
}

class { 'apache':
  default_vhost => false,
  mpm_module    => 'prefork', # needed for mod_php
}

apache::vhost { 'acc':
	vhost_name    => '*',
	port          => '80',
	docroot       => '/vagrant/html',
	docroot_owner => 'www-data',
	docroot_group => 'www-data',
	override      => ['All'],
}

class { 'apache::mod::rewrite': }
class { 'apache::mod::php': }

package { ['php-mysql', 'php-curl']: }

package { 'composer': }

vcsrepo { '/vagrant/html/waca':
	ensure   => present,
	provider => git,
	source   => 'https://github.com/enwikipedia-acc/waca.git',
}

exec { 'composer install':
	require => Vcsrepo['/vagrant/html/waca'],
	cwd     => '/vagrant/html/waca',
	command => '/usr/bin/env bash -c "COMPOSER_HOME=/root/.composer composer install"', # run in bash for env variables
	creates => '/vagrant/html/waca/vendor',
}

file { '/vagrant/html/waca/config.local.inc.php':
	require => Vcsrepo['/vagrant/html/waca'],
	ensure => link,
	target => '/vagrant/config/.config.vagrant.inc.php',
}

class { '::mysql::server':
	create_root_my_cnf      => true,
	root_password           => 'vagrant',
	remove_default_accounts => true,
	restart                 => true,
	override_options        => {
		'client' => {
			pager  => 'less -inSFX',
			prompt => '(\R:\m)\_\u@\h:[\d]>\_',
		},
	},
}

mysql::db { 'acc':
	user     => 'acc',
	password => 'vagrant',
	host     => 'localhost',
	grant    => ['ALL'],
}

exec { 'sql-provision':
	require => [
		Exec['composer install'],
		File['/vagrant/html/waca/config.local.inc.php'],
		Mysql::Db['acc'],
	],
	cwd     => '/vagrant/html/waca',
	command => '/vagrant/provision-db.sh',
	creates => '/vagrant/html/waca/.sql-setup',

}

exec { 'generate-resources':
	require => [
		Exec['sql-provision'],
	],
	cwd     => '/vagrant/html/waca',
	command => '/usr/bin/env php maintenance/RegenerateStylesheets.php',
	creates => '/vagrant/html/waca/resources/generated',
}
