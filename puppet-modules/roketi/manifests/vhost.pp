
define roketi::vhost($server, $type, $domains) {

	user { "${name}":
		ensure     => present,
		managehome => true,
	}

	file { "/home/${name}/www":
		ensure  => directory,
		require => User["${name}"],
	}

	file { "/home/${name}/www/index.html":
		ensure  => present,
		content => "Webroot for ${domains}",
	}
	
}

