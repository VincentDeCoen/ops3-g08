## LEMP-stack met WordPress

Om snel een LEMP-stack met werkende WordPress-applicatie, een blog opgevuld met posts en comments, te verkrijgen:
`vagrant up lempstack` vanuit de directory /lempstack in deze repository.

Prerequisites als je monitoring en DNS wil gebruiken:

- Om monitoring-gegevens te kunnen opvangen: de monitoring-server zoals gedefinieerd in Vagrant-omgeving `lampstack`. Je moet deze dus **niet opnieuw aanmaken** om hem voor deze server te kunnen gebruiken (zie onder).
- Voor dns: de DNS-server zoals gedefinieerd in `lampstack`, met een entry voor de LEMP-stack-server in `bind_zone_hosts`  

        - name: 'lempstack'
          ip: 192.168.56.66
          aliases:
            - lemp

### IP van machine en site

Het IP is `192.168.56.66`  
De WordPress-site is te bereiken op `192.168.56.66`

### Rollen voor LEMP-stack

Rollen common, nginx, php-fpm, mariadb en wordpress zijn overgenomen met aanpassingen uit de [voorbeelden van Ansible playbooks](https://github.com/ansible/ansible-examples) op GitHub.

```
# host_vars/lempstack.yml
- hosts: lempstack
  sudo: true
  roles:
    - bertvv.collectd
    - common
    - nginx
    - php-fpm
    - mariadb
    - wordpress
  post_tasks:
    - name: Import wordpress database
      mysql_db: name=wordpress_db state=import target=/vagrant/ansible/roles/common/files/wpdump.sql
```

De WordPress-database is dezelfde als die in de lampstack, enkel **site-url en home-url** zijn aangepast naar `192.168.56.66`:

        INSERT INTO `wp_options` VALUES (1,'siteurl','http://192.168.56.66','yes'),(2,'home','http://192.168.56.66','yes') ...

### Monitoring

Zoals voor de LAMP-stack bepaalt rolvariabele `collectd_server` in `group_vars/all.yml` of de machine collectd-server of client is. De waarde is hetzelfde als voor de LAMP-stack: `192.168.56.70`

LET OP!

In deze Vagrant-omgeving (`vagrant_hosts.yml`) **geen nieuwe hosts monitoring en dns** opnemen!

- Dit creëert een conflict voor Vagrant als machines met dezelfde naam in een andere Vagrant-omgeving voorkomen, bijvoorbeeld in lampstack.
- Dit is overbodig: monitoring en dns zitten in hetzelfde subnet, deze servers zullen de LEMP-stack-server dus vanzelf 'zien'.
