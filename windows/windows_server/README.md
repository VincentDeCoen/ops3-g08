### AsSv1


#### Scripts
In deze map bevinden zich de scripts voor de Windows Server 2012.

###### 1. Basis_conf.ps1
In dit script bevinden zich de basisfuncties als:  
`Rename, SetIP, setFirewall, Restart`.  
Om alle functies tegelijk uit te voeren, gebruik je de overkoepelende functie `basiscommandos`.

##### CSV-bestand: AsCSV.csv


#### Testomgeving

##### Machine aanmaken

`vagrant up` vanuit deze map creëert een Windows Server 2012R2 Standard - Core edition VM met 1 NAT-adapter en 1 Host-only netwerkadapter.
De eerste keer dat je dit doet wordt de base box kensykora/windows_2012_r2_standard_core gedownload.

Admin username/paswoord: vagrant/vagrant.

##### Powershell starten op de VM

1. Log in (vagrant/vagrant).
2. Insert Ctrl-Alt-Delete (Host key + Del)
3. Task Manager > File > Run new task...
4. Geef in: powershell.exe

##### Bronnen:

- desired state: https://gallery.technet.microsoft.com/scriptcenter/xActiveDirectory-f2d573f3
- https://technet.microsoft.com/en-us/library/jj590751%28v=wps.630%29.aspx
- https://technet.microsoft.com/en-us/library/dd347728.aspx
- https://technet.microsoft.com/en-us/library/hh826150.aspx
- https://docs.labtechsoftware.com/knowledgebase/article/5659
