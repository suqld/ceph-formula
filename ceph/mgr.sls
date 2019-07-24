# -*- coding: utf-8 -*-
# vim: ft=yaml

{% from "ceph/map.jinja" import ceph with context -%}

{% set mgr_name = grains['host'] %}
{% set mgr_dir = '/var/lib/ceph/mgr/ceph-' ~ mgr_name %}

mkdir_mgr_for_{{ mgr_name }}:
  file.directory:
    - name: {{ mgr_dir }}
    - user: ceph
    - group: ceph

mgr_auth_key_{{ mgr_name }}:
  cmd.run:
    - name: "ceph auth get-or-create mgr.{{ mgr_name }} mon 'allow profile mgr' osd 'allow *' mds 'allow *' > {{ mgr_dir }}/ceph-{{ mgr_name }}/keyring"
    - unless: 'test -e {{ mgr_dir }}/ceph-{{ mgr_name }}/keyring'

start_mgr_service_for_{{ mgr_name }}:
  service.running:
     - name: ceph-mgr@{{ mgr_name }}
     - enable: True
