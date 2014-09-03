
class puppet::hiera_http {

	# required Packages
	package {
		'ruby1.9.1-dev': ensure => installed;
	}
	
	# hiera-http gem
	exec { 'Install hiera-http gem':
		require     => Package['ruby1.9.1-dev'],
		command     => '/usr/bin/gem install hiera-http',
		unless      => '/usr/bin/gem list hiera-http | /bin/grep hiera-http',
	}

}

