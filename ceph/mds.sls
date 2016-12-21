# -*- coding: utf-8 -*-
# vim: ft=yaml

{% from "ceph/map.jinja" import settings with context -%}

{% set mds_name = grains['id'] %}
{% set mds_dir = salt['cmd.run']('ceph-mds  --id ' ~ mds_name ~ ' --show-config-value mds_data') %}

mkdir_dir_for_{{ mds_name }}:
  file.directory:
    - name: {{ mds_dir }}
    - user: ceph
    - group: ceph

add_mds_keyring_{{ mds_name }}:
  cmd.run:
    - name: "ceph auth get-or-create mds.{{ mds_name }} 'allow ' osd 'allow *' mon 'allow rwx' > {{ mds_dir }}/keyring"
    - unless: 'test -d {{ mds_dir }}/keyring'

start_mds_service_for_{{ mds_name }}:
  service.running:
     - enable: True
     - name: ceph-mds@{{ mds_name }}
