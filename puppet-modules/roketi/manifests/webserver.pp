
class roketi::webserver {

	$vHosts = hiera('roketi::webserver::vHosts')
	create_resources(roketi::vhost, $vHosts)

}

