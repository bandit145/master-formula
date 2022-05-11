

def test_salt_master_up(host):
	assert host.service('salt-master').is_running
	assert host.service('salt-master').is_enabled