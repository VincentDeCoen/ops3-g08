## Lastenboek Taak 1: Linux

* Verantwoordelijke uitvoering: `Birgit Croux`
* Verantwoordelijke testen: `Robbe Van Daele`

### Deliverables

* Opstellingen zoals beschreven in Deeltaken + demo
* Code nodig voor reproduceren opstellingen (GitHub)
* Verslag/documentatie opstellingen + analyseresultaten
* Ruwe data (resultaat van uitvoering testscenario's)
* (Optioneel) Presentatie (Engelstalig) over werkwijze en resultaten
* Testplan
* Testrapport

### Deeltaken

#### Opstelling 1. Enkelvoudige LAMP-stack

1. LAMP-stack met applicatie (Wordpress) + opgevulde DB + collectd (client-side config)
2. Monitoring-server: collectd (server-side config)
3. DNS-server
4. Load-testing: testscenario's  
5. Testscenario's uitvoeren, data opslaan en verwerken (grafieken)
  -> afhankelijk van: taak 1.1-1.5

#### Opstelling 2. Multi-tier web service

1. LEMP-stack (~~Apache~~ -> nginx) met applicatie (Wordpress) + opgevulde DB + collectd (client-side config)
2. Aparte database-server + webserver(s)
3. Parallelle webservers  
  -> afhankelijk van: taak 2.2
4. DNS-server (= taak 1.3)
5. Load balancer (aparte node)
6. DNS-server als load balancer
  -> afhankelijk van: taak 2.4
7. Reverse cache
  evt. op de load balancer, dan -> afhankelijk van: 2.5

### Kanban-bord

![Afbeelding huidige toestand Kanban-bord(en) invoegen](/weekrapport/media/w07/kanbanlinux.png "huboard team")

### Tijdbesteding

| Student  | Geschat | Gerealiseerd |
| :---     |    ---: |         ---: |
| Vincent De Coen |         |              |
| Ruben Piro |          |              |
| Robbe Van Daele |          |              |
| Birgitta Croux |         |              |
| Josey De Smet|         |              |


(na oplevering van de taak een schermafbeelding toevoegen van rapport tijdbesteding voor deze taak)
