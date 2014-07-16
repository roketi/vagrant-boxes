
# TODO: make Configurable

class roketi::panel {

	notify { "Hi! I'm the Roketi-Panel Server.": }

	# Clone Panel
	vcsrepo { '/var/www/panel':
		ensure   => present,
		provider => git,
		source   => 'https://github.com/roketi/panel.git',
	}

	# include nginx
	class { 'nginx':
		vhost_purge => true,
		confd_purge => true,
	}

	# vHost for Panel
	nginx::resource::vhost { $fqdn:
		www_root         => '/var/www/panel',
	}

	# PHP
	# TODO: Install PHP, create FPM Pool and appropriate nginx Configuration

	# Database
	# TODO: Create roketi Database

}

