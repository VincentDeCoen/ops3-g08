## Testplan en -rapport taak 1: (titel)

* Verantwoordelijke uitvoering: Birgit
* Verantwoordelijke testen: Vincent

### Testplan

Auteur(s) testplan: Vincent

- De twee servers, 'lampstack' en 'monitoring', worden opgezet via het 'Vagrant up' commando.
- Daarna zal naar de webpagina's van de servers gesurft worden om de services te testen.

### Testrapport

Uitvoerder(s) test: Vincent

- Na toevoegen van de roles dmv role-deps.sh script verloopt het opzetten van de servers dmv vagrant up vlekkenloos.
- Om de Lampstack server te testen surfen we naar 192.168.56.77/wordpress/
  - We krijgen een webpagina met blogberichten te zien, we kunnen ook zoekopdrachten uitvoeren.
- Om de Monitoring server te bekijken surfen we naar 192.168.56.70/collectd/
  - We krijgen de monitoring service te zien. We kunnen een server kiezen alsook de data die we wensen te zien (cpu, interface, load, memory)
    - We testen de Lamp webserver simpel door zeer snel pagina's te openen op de website(rechtsklik openen op nieuw tabblad). We zien een kleine piek in de monitoring grafieken.
