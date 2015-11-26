## Testplan en -rapport Simple Lamp

* Verantwoordelijke uitvoering: Birgit
* Verantwoordelijke testen: Vincent

### Testplan

Auteur(s) testplan: Birgit

- Servers 'lampstack', 'monitoring' en 'dns', worden opgezet via het 'vagrant up' commando.
- Op lampstack is een wordpress-blog aanwezig.
- Op monitoring is de interface van collectd-web zichtbaar.

### Testrapport

Uitvoerder(s) test: Vincent

- Na toevoegen van de roles dmv role-deps.sh script verloopt het opzetten van de servers dmv vagrant up vlekkenloos.
- Om de Lampstack server te testen surfen we naar 192.168.56.77/wordpress/
  - We krijgen een webpagina met blogberichten te zien, we kunnen ook zoekopdrachten uitvoeren.
- Om de Monitoring server te bekijken surfen we naar 192.168.56.70/collectd/
  - We krijgen de monitoring service te zien. We kunnen een server kiezen alsook de data die we wensen te zien (cpu, interface, load, memory)
    - We testen de Lamp webserver simpel door zeer snel pagina's te openen op de website(rechtsklik openen op nieuw tabblad). We zien een kleine piek in de monitoring grafieken.
-  Om de DNS server te testen zullen we via het hostsysteem werken. Eerst gaan we in de Windows Cmd een de DNS pingen en daarna een NSLookup commando doen.
  - ping 192.168.56.10
  - nslookup testdomein.lan 192.168.56.10
De ping werkt en de nslookup geeft de gevraagde informatie terug.
