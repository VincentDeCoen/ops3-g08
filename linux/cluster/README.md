## Web cluster met load balancing (HAProxy)


Cluster van LEMP-stacks met WordPress-installatie, remote database server en load balancer:

`vagrant up lb web1 web2 db2` vanuit de directory /remotedb in deze repository.

Prerequisites als je monitoring en DNS wil gebruiken:

- Om monitoring-gegevens te kunnen opvangen: de monitoring-server zoals gedefinieerd in Vagrant-omgeving `lampstack`. Je moet deze dus **niet opnieuw aanmaken** om hem voor deze server te kunnen gebruiken (zie onder).
- Voor dns: de DNS-server zoals gedefinieerd in `lampstack`, met een entry voor de 2 servers in `bind_zone_hosts`  

        - name: 'db2'
          ip: 192.168.56.60
        - name: 'web1'
          ip: 192.168.56.61
        - name: 'web2'
          ip: 192.168.56.62
        - name: lb
          ip: 192.168.56.20
          aliases:
            - blog

Je kan het load-balancingalgoritme instellen door de waarde van hostvariabele `balance` in te stellen in /host_vars/lb.yml.

### IP van machine en site

Het IP van de loadbalancer is `192.168.56.20`
Het IP van web1 is `192.168.56.61`  
Het IP van web2 is `192.168.56.62`
Het IP van db2 is `192.168.56.60`  
De WordPress-site is te bereiken op `192.168.56.20`, dit is dus het adres van de loadbalancer.

### Rollen voor het cluster

Rollen common, nginx, php-fpm, mariadb en wordpress en haproxy zijn overgenomen met aanpassingen uit de [voorbeelden van Ansible playbooks](https://github.com/ansible/ansible-examples) op GitHub.

```
- hosts: web1
  sudo: true
  roles:
    - bertvv.collectd
    - bertvv.el7
    - common
    - nginx
    - php-fpm
    - wordpress

- hosts: web2
  sudo: true
  roles:
    - bertvv.collectd
    - bertvv.el7
    - common
    - nginx
    - php-fpm
    - wordpress


- hosts: db2
  sudo: true
  roles:
    - bertvv.el7
    - bertvv.collectd
    - common
    - mariadb
  post_tasks:
    - name: Import wordpress database
      mysql_db:
        name: wordpress_db
        state: import
        target: /vagrant/ansible/roles/common/files/wpdump.sql

- hosts: lb
  sudo: true
  roles:
    - haproxy
```

De WordPress-database is dezelfde als die in de lampstack, enkel **site-url en home-url** zijn aangepast naar `192.168.56.20`:

        INSERT INTO `wp_options` VALUES (1,'siteurl','http://192.168.56.20','yes'),(2,'home','http://192.168.56.20','yes') ...

### Monitoring

Zoals voor de LAMP-stack bepaalt rolvariabele `collectd_server` in `group_vars/all.yml` of de machine collectd-server of client is. De waarde is hetzelfde als voor de LAMP-stack: `192.168.56.70`

LET OP!

In deze Vagrant-omgeving (`vagrant_hosts.yml`) **geen nieuwe hosts monitoring en dns** opnemen!

- Dit creëert een conflict voor Vagrant als machines met dezelfde naam in een andere Vagrant-omgeving voorkomen, bijvoorbeeld in lampstack.
- Dit is overbodig: monitoring en dns zitten in hetzelfde subnet, deze servers zullen de LEMP-stack-server en de database-server dus vanzelf 'zien'.
