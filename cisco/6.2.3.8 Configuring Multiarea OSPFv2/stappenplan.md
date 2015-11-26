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

####2) Configuring the Switches
