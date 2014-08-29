# roketi Panel

class roketi::panel (
  $ensure           = present,
  $install_location = '/var/www/panel',
  $install_source   = 'https://github.com/roketi/panel.git',
  $flow_context     = 'Development',
  $db_name          = 'roketi_dev',
  $db_username      = 'roketi_dev',
  $db_password      = 'roketi_dev',
  $panel_username   = 'admin',
  $panel_password   = 'changeme',
) {

	# Clone Panel
	vcsrepo { "${install_location}":
		ensure   => present,
		provider => git,
		source   => "${install_source}",
		notify   => Exec['panel_composer_install'],
	}

	# Flow Configuration
	file { "${install_location}/Configuration/Development/Settings.yaml":
		require => Vcsrepo["${install_location}"],
		content => template('roketi/panel_flow_settings.yaml.erb'),
		owner   => 'www-data',
		group   => 'www-data',
		mode    => '0600',
	}

	# Install dependencies
	exec { 'panel_composer_install':
		refreshonly => true,
		require     => [ Vcsrepo["${install_location}"], Class['php::cli'], ],
		environment => "COMPOSER_HOME=${install_location}",
		command     => "/usr/local/bin/composer install --working-dir ${install_location}",
		notify      => Exec['panel_behat_setup'],
	}

	# Setup Behat
	exec { 'panel_behat_setup':
		refreshonly => true,
		require     => Exec['panel_composer_install'],
		environment => "COMPOSER_HOME=${install_location}",
		command     => "${install_location}/flow behat:setup",
		notify      => Exec['panel_fix_permissions'],
	}

	# Fix permissions
	exec { 'panel_fix_permissions':
		refreshonly => true,
		environment => "FLOW_CONTEXT=${flow_context}",
		command     => "${install_location}/flow core:setfilepermissions vagrant www-data www-data",
		notify      => Exec['panel_doctrine_migrate'],
	}

	# Setup DB Schema
	exec { 'panel_doctrine_migrate':
		refreshonly => true,
		require     => [ Exec['panel_composer_install'], Mysql::Db["${db_name}"], ],
		environment => "FLOW_CONTEXT=${flow_context}",
		command     => "${install_location}/flow doctrine:migrate",
		notify      => Exec['panel_admin_user'],
	}

	# Create Admin User
	exec { 'panel_admin_user':
		environment => "FLOW_CONTEXT=${flow_context}",
		require     => Exec['panel_doctrine_migrate'],
		refreshonly => true,
		command     => "${install_location}/flow Roketi.Panel:setup:createadminuser --username '${panel_username}' --password '${panel_password}'",
	}

	# Cache Warmup
	exec { 'panel_cache_warmup':
		environment => "FLOW_CONTEXT=${flow_context}",
		require     => Exec['panel_doctrine_migrate'],
		command     => "${install_location}/flow flow:cache:warmup",
	}

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
	mysql::db { "${db_name}":
		user     => "${db_username}",
		password => "${db_password}",
		host     => 'localhost',
	}

}

