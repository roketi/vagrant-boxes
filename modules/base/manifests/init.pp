# Class: base

class base {

	# Hiera Configuration
	class { '::puppet::hiera_http': }

	# additional Modules
	hiera_include('base::modules', [''])
	
	# default Packages
	package {
		'screen':          ensure => installed;
		'htop':            ensure => installed;
		'git':             ensure => installed;
	}

}

