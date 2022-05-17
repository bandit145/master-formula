# /etc/yum.repos.d/salt.repo:
#   file.managed:
#     - source: salt://master/templates/salt.repo
#     - template: jinja
salt_repo:
  # cmd.run:
  #   - name: rpm --import https://repo.saltproject.io/py3/redhat/{{ grains['osmajorrelease'] }}/x86_64/{{ grains['salt_major_version'] }}/SALTSTACK-GPG-KEY.pub
  #   - creates:
  #       - /etc/pki/SALTSTACK-GPG-KEY.pub
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

configure_salt_top_file:
  file.managed:
    - name: "/srv/salt/top.sls"
    - source: salt://master/templates/top
    - template: py