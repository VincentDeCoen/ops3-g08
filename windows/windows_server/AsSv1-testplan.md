## Testplan en -rapport Windows Server

* Verantwoordelijke uitvoering: Ruben Piro
* Verantwoordelijke testen: Vincent De Coen

### Testplan
######Auteur testplan: Ruben Piro

####Testen Met Windows Server 2012 Met GUI (zonder vagrant)
  - Start de virtuele machine Windows Server 2012 Gui op (GUI bevat de Guest Additions)
  - Om te testen, plaats je het script ```AsScript.ps1``` en CSV-bestand ```AsCSV.csv``` op het bureaublad.
  - Start Powershell, doe ```cd Desktop``` en voer het commando ```./Desktop/AsScript.ps1``` uit.
  - Nu moet de virtuele machine heropstarten en is het script uitgevoerd.

#####Checklist Windows Server 2012 Met GUI
- [ ] Virtuele machine Windows Server 2012 Met GUI 
- [ ] Het script en csv-bestand staan op het bureaublad
- [ ] Na het uitvoeren van het script, zijn volgende zaken geïnstalleerd:  
  - [ ] Ip settings
  - [ ] AD
  - [ ] DNS
  - [ ] DHCP
  - [ ] OU's (beheer, verzekeringen,...)
  - [ ] De CSV-gebruikers zijn aangemaakt

### Testrapport

######Uitvoerder(s) test: Vincent De Coen

- ...
