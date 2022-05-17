import requests
import urllib3

urllib3.disable_warnings()

def test_salt_master_up(host):
	assert host.service('salt-master').is_running
	assert host.service('salt-master').is_enabled

def test_api(host):

	assert host.service('gunicorn').is_running
	assert host.service('gunicorn').is_enabled
	assert host.service('nginx').is_running
	assert host.service('nginx').is_enabled
	ip = host.run("ip a show eth0 | awk 'NR==3{print $2}'").stdout.split('/')[0]
	resp = requests.get(f'https://{ip}/', verify=False)
	assert resp.json()['return'] == 'Welcome'