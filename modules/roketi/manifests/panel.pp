# roketi Panel

class roketi::panel (
  $ensure           = present,
  $install_location = '/var/www/panel',
  $install_source   = 'https://github.com/roketi/panel.git',
) {

	# Clone Panel
	vcsrepo { "${install_location}":
		ensure   => present,
		provider => git,
		source   => "${install_source}",
		notify   => Exec['panel-composer'],
	}

	# TODO
	# composer install --dev
	# chown www-data:
	# ./flow behat:setup
	# FLOW_CONTEXT=Development/Behat ./flow doctrine:migrate
	# FLOW_CONTEXT=Development/Behat ./flow Roketi.Panel:setup:createadminuser --username "john.doe" --password "12345"
	# FLOW_CONTEXT=Development/Behat ./flow flow:cache:warmup

	# include nginx
	class { 'nginx':
		vhost_purge => true,
		confd_purge => true,
	}

	# nginx Configuration
	nginx::resource::vhost { $fqdn:
		www_root         => "${install_location}/Web",
	}

	nginx::resource::location { "${fqdn}-fpm":
		ensure              => present,
		vhost               => $fqdn,
		location            => '~ [^/]\.php(/|$)',
		www_root            => "${install_location}/Web",
		location_cfg_append => {
			'fastcgi_param'           => 'PATH_INFO $fastcgi_path_info',
			'fastcgi_param'           => 'SCRIPT_FILENAME $document_root$fastcgi_script_name',
			'fastcgi_split_path_info' => '^(.+\.php)(/.+)$',
			'fastcgi_pass'            => '127.0.0.1:9001',
			'fastcgi_index'           => 'index.php',
			'include'                 => 'fastcgi_params',
		},
	}

	# include PHP
	include php
	class { [
		'php::fpm',
		'php::cli',
		'php::extension::curl',
		'php::extension::mysql',
		'php::composer'
	]: }

	# PHP FPM Pool
	php::fpm::pool { 'www-data':
		listen  => '127.0.0.1:9001',
		user    => 'www-data',
		require => Package['nginx'],
	}

	# PHP FPM Configuration
	php::fpm::config { 'Roketi PHP FPM Configure Time Zone':
		setting => 'date.timezone',
		value   => 'Europe/Zurich',
		section => 'Date',
	}

	# PHP CLI Configuration
	php::cli::config { 'Roketi PHP CLI Configure Time Zone':
		setting => 'date.timezone',
		value   => 'Europe/Zurich',
		section => 'Date',
	}

	# include MySQL
	class { '::mysql::server': }

	# Database
	mysql::db { 'roketi_testing':
		user     => 'roketi_testing',
		password => 'roketi_testing',
		host     => 'localhost',
	}

}

