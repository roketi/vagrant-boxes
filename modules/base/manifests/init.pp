# Class: base

class base {

	# additional Modules
	hiera_include('base::modules', [''])
	
	# default Packages
	package {
		'screen':          ensure => installed;
		'htop':            ensure => installed;
		'git':             ensure => installed;
	}

}

