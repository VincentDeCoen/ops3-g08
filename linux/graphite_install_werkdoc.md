## Graphite

Opmerking: deze installatie is (nog) niet geautomatiseerd. Dit is enkel de neerslag van de uitgevoerde commando's.

### Installatie

##### Dependencies: <http://graphite.readthedocs.org/en/latest/install.html#dependencies>
Ter info: dependencies checken kan met:
  - `yum list installed | grep NAME`
  - `yum info PACKAGE_NAME` geeft info over bepaalde package

yum -y update;
yum install -y net-snmp perl pycairo mod_wsgi python-devel git gcc-c++;

##### Pip

yum -y python-pip nodejs npm

##### Graphite

pip install 'django<1.6' 'Twisted<12' 'django-tagging<0.4' whisper graphite-web carbon

##### Statsd

git clone https://github.com/etsy/statsd.git /usr/local/src/statsd/

##### Database (PostgreSQl)
Default database is SQLite, voor de cluster van de volgende opdracht hebben we sowieso een 'echte' DBMS nodig.

yum install postgresql postgresql-server postgresql-devel python-psycopg2  
sudo systemctl start postgresql  
sudo systemctl enable postgresql  
sudo -u postgres psql  
CREATE USER graphite WITH PASSWORD 'BulpashCod';  
CREATE DATABASE graphite WITH OWNER graphite;  
\\q

sudo cp /opt/graphite/webapp/graphite/local_settings.py.example /opt/graphite/webapp/graphite/local_settings.py

sudo vi /opt/graphite/webapp/graphite/local_settings.py

  * salt string:
        SECRET_KEY = 'saltnpeppa'
  * tijdzone:
        TIME_ZONE = 'Europe/Brussels'
  * authenticatie webapp
        USE_REMOTE_USER_AUTHENTICATION = True
  * database ~ postgresql:
          DATABASES = {
              'default': {
                  'NAME': 'graphite',
                  'ENGINE': 'django.db.backends.postgresql_psycopg2',
                  'USER': 'graphite',
                  'PASSWORD': 'BulpashCod',
                  'HOST': '127.0.0.1',
                  'PORT': ''
              }
          }

(Zorgen dat Postgres de juiste authenticatie toelaat (md5 i.p.v. ident))  
sudo vi /var/lib/pgsql/data/pg_hba.conf
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5

sudo systemctl restart postgresql

sudo python /opt/graphite/webapp/graphite/manage.py syncdb

Wanneer gevraagd wordt om een superuser aan te maken (= om in te loggen in Graphite zodat je grafieken kan opslaan en de interface kan aanpassen), doe dit.
Bvb. l/p ops-user/BulpashCod

### Configuratie

Configuratie o.b.v. meegeleverde templates Graphite:

cp /opt/graphite/examples/example-graphite-vhost.conf /etc/httpd/conf.d/graphite.conf
cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf
cp /opt/graphite/conf/storage-aggregation.conf.example /opt/graphite/conf/storage-aggregation.conf
cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
cp /opt/graphite/conf/graphTemplates.conf.example /opt/graphite/conf/graphTemplates.conf
cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf

Zorgen dat Apache naar de database kan schrijven:
chown -R apache:apache /opt/graphite/storage/

Configuratie van [dataretentie voor whisper](http://graphite.readthedocs.org/en/latest/config-carbon.html).
D.i. precisie (tijd tussen datapunten): historiek (hoe lang bijhouden)

vi /opt/graphite/conf/storage-schemas.conf

(Voorlopig) ingesteld op:

        [default]
        pattern = .*
        retentions = 10s:4h, 60s:1d, 5m:8d, 15m:30d, 1h:1y

Start carbon service:
Opm: dit gebeurt voorlopig manueel.
//TODO carbon cache starten bij boot

sudo /opt/graphite/bin/carbon-cache.py start

### Referenties

- [Tutorial voor Ubuntu Graphite](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-graphite-on-an-ubuntu-14-04-server) met heel veel duidelijke uitleg over Graphite en componenten, statsd, collectd
- [PostgreSQL op CentOS7](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-centos-7)
