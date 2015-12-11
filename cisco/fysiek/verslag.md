## Laboverslag: Fysieke opstelling van het labo 6.2.3.8

- Studenten: Ruben Piro, Vincent De Coen, Birgitta Croux
- Repository: https://github.com/HoGentTIN/ops3-g08

### De Voorbereiding
  1. Neem 1 seriële kabel
  2. Neem 3 Routers
  3. Start 1 PC op
  4. Verbind de apparaten volgens de illustratie uit de opdracht

Om de routers te configureren hebben we ons stappenplan van Labo 6.2.3.8 gebruikt. Het stappenplan bevat volgende stappen:

####1) Configuring the basic settings for each router
#####1.1) R1
<pre>
en 
conf t
hostname R1
int lo0
ip address 209.165.200.225 255.255.255.252
int lo1
ip address 192.168.1.1 255.255.255.0
int lo2 
ip address 192.168.2.1 255.255.255.0
int s0/1/0
clock rate 128000
bandwidth 128
ip address 192.168.12.1 255.255.255.252
no shutdown
</pre>
#####1.2) R2
<pre>
en
conf t
hostname R2
int lo6
ip address 192.168.6.1 255.255.255.0
int s0/1/0
bandwidth 128
ip address 192.168.12.2 255.255.255.252
no shutdown

int s0/1/1
bandwidth 128
clock rate 128000
ip address 192.168.23.1 255.255.255.252
no shutdown
</pre>

#####1.3) R3
<pre>
en
conf t
hostname R3
int lo4 
ip address 192.168.4.1 255.255.255.0
int lo5
ip address 192.168.5.1 255.255.255.0
int s0/1/1
bandwidth 128
ip address 192.168.23.2 255.255.255.252
no shutdown
</pre>

####2) Verify the settings
```show ip interface brief```

####3) Configure OSPF 
#####3.1) R1
<pre>
router ospf 1
router-id 1.1.1.1
do show ip route connected
network 192.168.1.0 0.0.0.255 area 1
network 192.168.2.0 0.0.0.255 area 1
network 192.168.12.0 0.0.0.3 area 0

passive-interface lo1
passive-interface lo2
exit
ip route 0.0.0.0 0.0.0.0 lo0
router ospf 1
default-information originate
</pre>

#####3.2) R2
<pre>
router ospf 1
router-id 2.2.2.2
do show ip route connected
network 192.168.6.0 0.0.0.255 area 3
network 192.168.12.0 0.0.0.3 area 0
network 192.168.23.0 0.0.0.3 area 3
passive-interface lo6
</pre>

#####3.3) R3

<pre>
router ospf 1
router-id 3.3.3.3
do show ip route connected
network 192.168.4.0 0.0.0.255 area 3
network 192.168.5.0 0.0.0.255 area 3
network 192.168.23.0 0.0.0.3 area 3
passive-interface lo4
passive-interface lo5
</pre>

#####3.4) Verify OSPF settings
<pre>show ip protocols
show ip ospf interface brief</pre>

#####3.5) MD5
######3.5.1) R1
<pre>
conf t
int s0/1/0
ip ospf message-digest-key 1 md5 cisco123
ip OSPF authentication message-digest
</pre>

######3.5.2) R2
<pre>
conf t
int s0/1/0
ip ospf message-digest-key 1 md5 cisco123
ip OSPF authentication message-digest

int s0/1/1
ip ospf message-digest-key 1 md5 cisco123
ip OSPF authentication message-digest
</pre>

######3.5.3) R3
<pre>
conf t
int s0/1/1
ip ospf message-digest-key 1 md5 cisco123
ip OSPF authentication message-digest
</pre>
<pre>show ip ospf neighbor</pre>

####4) Configure Interarea Summary Routes
<pre>show ip route ospf
show ip ospf database</pre>

#####4.1) R1
<pre>
router ospf 1
area 1 range 192.168.0.0 255.255.252.0
</pre>

#####4.2) R2
<pre>
router ospf 1
area 3 range 192.168.0.0 255.255.252.0
</pre>

#####4.2) R3
<pre>
router ospf 1
area 3 range 192.168.4.0 255.255.252.0
</pre>


### Wat ging er goed? Wat ging er slecht? 

Zo goed als alles ging goed en vlot. Het fysieke netwerk was rap in elkaar gestoken. We hebben in het verleden al gebruik gemaakt van Tera Term dus we weten hoe we een Router moeten configureren. 

Er was enkel een klein verschil in de labo's; de fysieke routers hadden andere seriële poorten, en ze hadden ook fast ethernet poorten in plaats van Gigabit poorten.

We hadden ook per ongeluk een verkeerde poort geconfigureerd waardoor de routers verkeerde 'neighbors' hadden. Na een paar minuten troubleshooten en bekijken van configuratiebestanden was het probleem opgelost.
