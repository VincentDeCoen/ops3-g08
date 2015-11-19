## DNS

### Stappenplan om de DNS op te zetten

In Vagrant_hosts.yml bijvoegen:
```
- name: dns
  ip: 192.168.56.10
```

In Site.yml bijvoegen:

```
- hosts: dns
  sudo: true
  roles:
    - bertvv.el7
    - bertvv.bind

```

In host_vars 'dns.yml' aanmaken met volgende inhoud:
```
bind_zone_master_server_ip: 192.168.56.10
bind_zone_networks:
  - '192.168.56'
bind_zone_hosts:
  - name: 'dns'
    ip: 192.168.56.10
    aliases:
      - ns
  - name: 'monitoring'
    ip: 192.168.56.70
    aliases:
      - mon
  - name: 'lampstack'
    ip: 192.168.56.77
    aliases:
      - ls
bind_allow_query:
  - 'any'
bind_listen_ipv4:
  - 'any'
bind_listen_ipv6:
  - 'any'
bind_zone_name_servers:
  - 'dns'
bind_zone_name: 'testdomein.lan'
bind_recursion: 'no'
bind_zone_minimum_ttl: '1D'
bind_zone_time_to_expire: '1W'
bind_zone_time_to_refresh: '1D'
bind_zone_time_to_retry: '1H'
bind_zone_ttl: '1W'
el7_firewall_allow_services:
  - http
  - https
  - dns
```
