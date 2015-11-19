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
```
#####S2
```
en
conf t
hostname S2
int range fa0/1-24, g0/1-2
```
#####S3
```
en
conf t
hostname S3
int range fa0/1-24, g0/1-2
```
####Configuring the VLAN's
#####S1
######Creating VLAN 10 and VLAN 99 
```
exit
vlan 10
name User
vlan 99
name Management
```
######Enable user ports in accessmode
```
exit
int fa0/6
switchport mode access
switchport access vlan 10
no shutdown
int range fa0/1,fa0/3
switchport mode trunk
switchport trunk native vlan 99
no shutdown
```
###### IP Settings VLAN's
```
conf t
int vlan 99
ip address 192.168.1.11 255.255.255.0
no shutdown
```
#####S2
######Creating VLAN 10 and VLAN 99 
```
exit
vlan 10
name User
vlan 99
name Management
```
######Enable user ports in accessmode
```
exit
int range fa0/1,fa0/3
switchport mode trunk
switchport trunk native vlan 99
no shutdown
```
###### IP Settings VLAN's
```
conf t
int vlan 99
ip address 192.168.1.12 255.255.255.0
no shutdown
```
#####S3
######Creating VLAN 10 and VLAN 99 
```
exit
vlan 10
name User
vlan 99
name Management
```
######Enable user ports in accessmode
```
exit
int fa0/18
switchport mode access
switchport access vlan 10
no shutdown
int range fa0/1,fa0/3
switchport mode trunk
switchport trunk native vlan 99
no shutdown
```
###### IP Settings VLAN's
```
conf t
int vlan 99
ip address 192.168.1.13 255.255.255.0
no shutdown
```
