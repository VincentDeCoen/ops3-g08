## Testplan en -rapport Windows Server

* Verantwoordelijke uitvoering: Ruben Piro
* Verantwoordelijke testen: Vincent De Coen

### Testplan
######Auteur testplan: Ruben Piro

#### 1)Testen Met Windows Server 2012 Met GUI (zonder vagrant)
  - Start de virtuele machine Windows Server 2012 Gui op (GUI bevat de Guest Additions)
  - Om te testen, plaats je alle scripts uit de folder en CSV-bestand ```AsCSV.csv``` op het bureaublad.
  - Start Powershell, doe ```cd Desktop```.
  - 1. De basissettings: Doe
   ```. ./1basis_conf.ps1``` en ```basiscommandos``` (om de overkoepelende functie uit te voeren die de basissettings maakt)
  - 2. AD: Doe ```. .\2ad_ou_conf.ps1```
  - 2.1 `AD` -> installeert alles van de AD
  - 2.2 `OU` -> installeert alles van de OU's en Users
  - 3. DHCP: doe ```. .\3dhcp_conf.ps1```
  - 3.1 `DHCP` -> installeert de DHCP (en scopes etc)
  - 4. Printers: doe ```. .\4printers_conf.ps1```

#####Checklist Windows Server 2012 Met GUI
- [ ] Virtuele machine Windows Server 2012 Met GUI 
- [ ] De scripts en csv-bestand staan op het bureaublad
- [ ] Na het uitvoeren van het script, zijn volgende zaken geïnstalleerd:  
  - [ ] Rename
  - [ ] Ip settings
  - [ ] AD
  - [ ] DNS
  - [ ] DHCP
  - [ ] OU's (beheer, verzekeringen,...)
  - [ ] De CSV-gebruikers zijn aangemaakt
  

### Testrapport

######Uitvoerder(s) test: Vincent De Coen

- Het volgen van de stappen verloopt vlekkenloos, de scripts doen wat er gezegd wordt.

######Instellingen controlleren

IP-instellingen controleren in Powershell:

```
Get-NetIPConfiguration -Detailed
```

Dit commando zal de instellingen van alle netwerkinterfaces tonen zoals Interfacenaam, ipv4- en ipv6-adres, de default-gateway, IP adres van de dns server tonen.

Active directory users bekijken

```
Get-AdUser -filter *
```

Configuratie van DNS server bekijken

```
Get-Dnsserver
```
