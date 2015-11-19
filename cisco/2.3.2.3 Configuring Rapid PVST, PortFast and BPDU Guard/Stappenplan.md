# 2.3.2.3 Configuring Rapid PVST, PortFast, and BPDU Guard

###Required:
- 3 Switches (cisco 2960)
- 2 PC's
- Console cables and ethernet cables

####Configuring the PC's
#####PC-A
```
IP Address: 192.168.0.2 255.255.255.0
```
#####PC-C
```
IP Address: 192.168.0.3 255.255.255.0
```

####Configuring the Switches
#####S1
```
en
conf t
hostname S1
int range fa0/1-24, g0/1-2
shutdown
```
#####S2
```
en
conf t
hostname S2
int range fa0/1-24, g0/1-2
shut
```
#####S3
```
en
conf t
hostname S3
int range fa0/1-24, g0/1-2
shut
```
####Configuring the VLAN's

