# 2.3.2.3 Configuring Rapid PVST, PortFast, and BPDU Guard

###Required:
- 3 Switches (cisco 2960)
- 2 PC's
- Console cables and ethernet cables

####1) Configuring the PC's
#####1.1) PC-A
```
IP Address: 192.168.0.2 255.255.255.0
```
#####1.2) PC-C
```
IP Address: 192.168.0.3 255.255.255.0
```

####2) Configuring the Switches
#####2.1) S1
```
en
conf t
hostname S1
int range fa0/1-24, g0/1-2
```
#####2.2) S2
```
en
conf t
hostname S2
int range fa0/1-24, g0/1-2
```
#####2.3) S3
```
en
conf t
hostname S3
int range fa0/1-24, g0/1-2
```
####3) Configuring the VLAN's
#####3.1) S1
######3.1.1) Creating VLAN 10 and VLAN 99 
```
exit
vlan 10
name User
vlan 99
name Management
```
######3.1.2) Enable user ports in accessmode
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
######3.1.3) IP Settings VLAN's
```
conf t
int vlan 99
ip address 192.168.1.11 255.255.255.0
no shutdown
```
#####3.2) S2
######3.2.1) Creating VLAN 10 and VLAN 99 
```
exit
vlan 10
name User
vlan 99
name Management
```
######3.2.2) Enable user ports in accessmode
```
exit
int range fa0/1,fa0/3
switchport mode trunk
switchport trunk native vlan 99
no shutdown
```
######3.2.3) IP Settings VLAN's
```
conf t
int vlan 99
ip address 192.168.1.12 255.255.255.0
no shutdown
```
#####3.3) S3
######3.3.1) Creating VLAN 10 and VLAN 99 
```
exit
vlan 10
name User
vlan 99
name Management
```
######3.3.2) Enable user ports in accessmode
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
######3.3.3) IP Settings VLAN's
```
conf t
int vlan 99
ip address 192.168.1.13 255.255.255.0
no shutdown
```

#####4) Check the configurations and connectivity
- show vlan brief
- show interfaces trink
- show running-config

####5) Configure the Root Bridge and Examine PVST+ Convergence
#####5.1) Configure primary root bridge S2
```
spanning-tree vlan 1 root primary
spanning-tree vlan 10 root primary
spanning-tree vlan 99 root primary
```

#####5.2) Configure secondary root bridge S1
```
spanning-tree vlan 1 root secondary
spanning-tree vlan 10 root secondary
spanning-tree vlan 99 root secondary
```

#####5.3) Debug the spanning tree (S3)
the command ```debug spanning-tree events``` didn't do anything at all.
```
en
conf t
int fa0/1
shutdown
```

####6) Configure Rapid PVST+, PortFast, BPDU Guard, and Examine Convergence
#####6.1) Rapid PVST+
######6.1.1) ALL switches
```
config t
spanning-tree mode rapid-pvst
```

#####6.1.2) PortFast & BPDU
######6.1.2.1) S1 fa0/6
```
conf t
int fa0/6
spanning-tree portfast
spanning-tree bpduguard enable
```

######6.1.2.2) S3
```
conf t
spanning-tree portfast default (configures all non-trunking ports on switch S3 with portfast)
spanning-tree bpduguard (configures all non-trunking ports on switch S3 with bpduguard)
```
```
int fa0/1
no shutdown
```
