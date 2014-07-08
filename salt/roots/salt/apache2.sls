apache2:
  pkg:
    - installed
    - name: apache2

  service:
    - running
    - reload: True
    - watch:
      - file: /etc/php.ini
      - file: /etc/apache2/sites-enabled/00-maw-vhosts.conf

/etc/php.ini:
  file.managed:
    - source: salt://php/php.ini

/etc/apache2/sites-enabled/00-maw-vhosts.conf:
  file.managed:
    - source: salt://apache2/vhosts/maw.conf