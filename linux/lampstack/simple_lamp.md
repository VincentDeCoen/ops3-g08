## LAMP-stack met WordPress

Om snel een LAMP-stack met werkende WordPress-applicatie, een blog opgevuld met posts en comments, te verkrijgen:
`vagrant up lampstack` vanuit de directory /lampstack in deze repository.

De blog is te bezoeken op 192.168.56.77/wordpress/ (wanneer de server draait, uiteraard).

* ansible/site.yml bevat een post task die na de provisionering ansible/roles/common/files/wpdump.sql importeert.  

          post_tasks:
            - name: import wordpress database
              mysql_db: name=wordpress_db state=import target=/vagrant/ansible/roles/common/files/wpdump.sql

* ansible/host_vars/lampstack.yml zorgt voor de provisionering van de juiste gebruikersgegevens (secties mariadb en httpd).  

          # mariadb
          mariadb_root_password: yagnolhu9OlOthUl
          mariadb_databases:
            - wordpress_db
          mariadb_users:
            - name: wordpress_usr
              password: 1OjejAfPod
              priv: wordpress_db.*:ALL

          # wordpress
          wordpress_database: wordpress_db
          wordpress_user: wordpress_usr
          wordpress_password: 1OjejAfPod

* Als de WordPress-site op een machine met een ander IP moet opgezet worden, moet je in wpdump.sql de **juiste site-url en home-url** invoeren bij de data voor tabel wp_options.  

          --
          -- Dumping data for table `wp_options`
          --
          ...
          INSERT INTO `wp_options` VALUES (1,'siteurl','http://192.168.56.77/wordpress','yes'),(2,'home','http://192.168.56.77/wordpress','yes') ...

* om de oorspronkelijke site op te vullen is gebruikt gemaakt van de WordPress-plugin Fakerpress.

## Collectd

Lampstack en monitoring zijn geconfigureerd voor het opzetten van collectd. Lampstack als client, monitoring als server. Hiervoor gebruiken we de rol bertvv.collectd uit Ansible Galaxy.

Een eenvoudige interface om de verzamelde stats te bekijken is (wanneer de server draait) te zien op 192.168.56.70/collectd/ (**inclusief de laatste slash**, anders krijg je een 404).

* Server 'monitoring' is toegevoegd in vagrant_hosts.yml  

        - name: monitoring
          ip: 192.168.56.70

* Rol bertvv.collectd is voor beide servers toegevoegd aan site.yml

* Monitoring is ingesteld als server voor collectd (client lampstack stuurt collectd-data via het netwerk naar de server). Dit gebeurt in group_vars/all.yml.

        # collectd server address
        collectd_server: 192.168.56.70

* De lampstack laat verkeer door op de poort(en) die collectd-plugin network gebruikt (group_vars/all.yml)  

          # allow traffic on collectd network plugin port
          el7_firewall_allow_ports:
                - 25826/udp
                - 25827/udp
