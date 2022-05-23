
salt_repo:
  pkgrepo.managed:
    - name: salt
    - baseurl: https://repo.saltproject.io/py3/redhat/{{ grains['osmajorrelease'] }}/x86_64/{{ pillar['salt_major_version'] }}
    - gpgcheck: 1
    - gpgkey: https://repo.saltproject.io/py3/redhat/{{ grains['osmajorrelease'] }}/x86_64/{{ pillar['salt_major_version'] }}/SALTSTACK-GPG-KEY.pub
    - humanname: salt-{{ pillar['salt_major_version'] }}-repo

install_and_configure_salt:
  pkg.installed:
    - pkgs:
        - salt-master
        - salt-cloud
        - salt-api
        - salt-minion
        - python3-pygit2
        - python3-gnupg

  file.managed:
    - name: /etc/salt/master
    - source: salt://master/templates/master
    - template: py

  service.running:
    - name: salt-master
    - enable: true
    - full_restart: true
    - onchanges:
      - file: /etc/salt/master

/etc/salt/gpgkeys:
  file.directory:
    - mode: 0600

#create gpg key for crypto

gpg.create_key:
  module.run:
    #- gpg.create_key:
    - key_length: 4096
    - key_type: RSA
    - user: salt
    - creates: /etc/salt/gpgkeys/pubring.kbx

GNUPGHOME=/etc/salt/gpgkeys gpg2 --export --armor > /etc/salt/gpg.pub:
  cmd.run:
    - creates: /etc/salt/gpg.pub


configure_salt_top_file:
  file.managed:
    - name: "/srv/salt/top.sls"
    - source: salt://master/templates/top
    - template: py