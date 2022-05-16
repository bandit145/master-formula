{% if "salt_master_api" in pillar.keys() %}
install_required_pkgs:
  pkg.installed:
    - pkgs:
      - nginx
      - python3-gunicorn

  {% if "salt_api_self_signed_cert" in pillar.keys() %}
/etc/pki/salt_api.key:
  x509.private_key_managed:
    - bits: 4096

/etc/pki/salt_api.crt:
  x509.certificate_managed:
    - signing_private_key: /etc/pki/salt_api.key
    - CN: "{{ pillar['salt_api_self_signed_cert']['CN'] }}"
    - C:  "{{ pillar['salt_api_self_signed_cert']['C'] }}"
    - ST: "{{ pillar['salt_api_self_signed_cert']['ST'] }}"
    - L: "{{ pillar['salt_api_self_signed_cert']['L'] }}"
    - days_valid: 3650
  {% endif %}

/usr/lib/systemd/system/gunicorn.service:
  file.managed:
    - source: salt://master/templates/gunicorn.service

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://master/templates/nginx.conf

gunicorn:
  cmd.run:
    - name: systemctl daemon-reload
    - watch:
      - file: /usr/lib/systemd/system/gunicorn.service
  service.running:
    - enable: true

nginx:
  service.running:
    - enable: true
    - full_restart: true
    - watch:
      - file: /etc/pki/salt_api.crt
      - file: /etc/pki/salt_api.key
      - file: /etc/nginx/nginx.conf

{%endif%}