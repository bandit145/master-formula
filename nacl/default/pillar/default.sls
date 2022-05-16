salt_major_version: 3004

salt_master_api: True

salt_master_top_config:
  base:
    '*':
      - master

salt_api_self_signed_cert:
  CN: salt-master.wifi.rr.com
  C: US
  ST: Colorado
  L: Denver

salt_master_config:
  # fileserver_backend:
  #   - gitfs

  file_roots:
    base:
      - /srv/salt/
      - /srv/formulas/master-formula

  pillar_roots:
    base:
      - /srv/formulas/master-formula/nacl/default/pillar/

  # gitfs_remotes:
  #   - https://github.com/saltstack-formulas/nginx-formula.git