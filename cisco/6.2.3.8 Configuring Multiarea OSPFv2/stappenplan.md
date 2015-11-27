# 6.2.3.8 Configuring Multiarea OSPFv2

###Required:
- 3 Routers
- Serial cables
!complete the network model!


####1) Configuring the basic settings for each router
#####1.1) R1
```
en 
conf t
hostname R1
int lo0
ip address 209.165.200.225 255.255.255.252
int lo1
ip address 192.168.1.1 255.255.255.0
int lo2 
ip address 192.168.2.1 255.255.255.0
int s0/0/0
clock rate 128000
bandwidth 128
ip address 192.168.12.1 255.255.255.252
no shutdown
```
#####1.2) R2
```
en
conf t
hostname R2
int lo6
ip address 192.168.6.1 255.255.255.0
int s0/0/0
bandwidth 128
ip address 192.168.12.2 255.255.255.252
no shutdown

int s0/0/1
bandwidth 128
clock rate 128000
ip address 192.168.23.1 255.255.255.252
no shutdown
```

#####1.3) R3
```
en
conf t
hostname R3
int lo4 
ip address 192.168.4.1 255.255.255.0
int lo5
ip address 192.168.5.1 255.255.255.0
int s0/0/1
bandwidth 128
ip address 192.168.23.2 255.255.255.252
no shutdown
```

####2) Verify the settings
```show ip interface brief```

####3) Configure OSPF 
#####3.1) R1
```
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
```

#####3.2) R2
```
router ospf 1
router-id 2.2.2.2
do show ip route connected
network 192.168.6.0 0.0.0.255 area 3
network 192.168.12.0 0.0.0.3 area 0
network 192.168.23.0 0.0.0.3 area 3
passive-interface lo6
```

#####3.3) R3

```
router ospf 1
router-id 3.3.3.3
do show ip route connected
network 192.168.4.0 0.0.0.255 area 3
network 192.168.5.0 0.0.0.255 area 3
network 192.168.23.0 0.0.0.3 area 3
passive-interface lo4
passive-interface lo5
```

#####3.4) Verify OSPF settings
```show ip protocols```
```show ip ospf interface brief```

#####3.5) MD5
######3.5.1) R1
```
conf t
int s0/0/0
ip ospf message-digest-key 1 md5 cisco123
ip OSPF authentication message-digest
```

######3.5.2) R2
```
conf t
int s0/0/0
ip ospf message-digest-key 1 md5 cisco123
ip OSPF authentication message-digest

int s0/0/1
ip ospf message-digest-key 1 md5 cisco123
ip OSPF authentication message-digest
```

######3.5.3) R3
```
conf t
int s0/0/1
ip ospf message-digest-key 1 md5 cisco123
ip OSPF authentication message-digest
```
```show ip ospf neighbor```

####4) Configure Interarea Summary Routes
```show ip route ospf``` on ALL Routers
```show ip ospf database```

#####4.1) R1
```
router ospf 1
area 1 range 192.168.0.0 255.255.252.0
```

#####4.2) R2
```
router ospf 1
area 3 range 192.168.4.0 255.255.252.0
```
