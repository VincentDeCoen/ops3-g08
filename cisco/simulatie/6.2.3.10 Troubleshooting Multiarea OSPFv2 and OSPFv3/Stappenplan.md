## Troubleshooting Multiarea OSPFv2 and OSPFv3 

#### In router 1
```
enable
conf t
hostname R1
enable secret class
ipv6 unicast-routing
no ip domain lookup
interface Loopback0
ip address 209.165.200.225 255.255.255.252
interface Loopback1
ip address 192.168.1.1 255.255.255.0
ipv6 address 2001:DB80:ACAD:1::1/64
ipv6 ospf network point-to-point
interface Loopback2
ip address 192.168.2.1 255.255.255.0
ipv6 address 2001:DB8:ACAD:2::1/64
ipv6 ospf 1 area 1
ipv6 ospf network point-to-point
interface Serial0/0/0
ip address 192.168.21.1 255.255.255.252
ipv6 address FE80::1 link-local
ipv6 address 2001:DB8:ACAD:12::1/64
ipv6 ospf 1 area 0
clock rate 128000
shutdown
router ospf 1
router-id 1.1.1.1
passive-interface Loopback1
passive-interface Loopback2
network 192.168.2.0 0.0.0.255 area 1
network 192.168.12.0 0.0.0.3 area 0
default-information originate
ipv6 router ospf 1
```
Volgend commando zullen we **niet** gebruiken daar Packet Tracer dit commando niet ondersteunt:

**area 1 range 2001:DB8:ACAD::/61**

```
ip route 0.0.0.0 0.0.0.0 Loopback0
banner motd @
Unauthorized Access is Prohibited! @
line con 0
password cisco
logging synchronous
login
line vty 0 4
password cisco
logging synchronous
login
transport input all
end
```

#### In router 2
```
enable
conf t
hostname R2
ipv6 unicast-routing
no ip domain lookup
enable secret class
interface Loopback6
ip address 192.168.6.1 255.255.255.0
ipv6 address 2001:DB8:CAD:6::1/64
interface Serial0/0/0
ip address 192.168.12.2 255.255.255.252
ipv6 address FE80::2 link-local
ipv6 address 2001:DB8:ACAD:12::2/64
ipv6 ospf 1 area 0
no shutdown
interface Serial0/0/1
ip address 192.168.23.2 255.255.255.252
ipv6 address FE80::2 link-local
ipv6 address 2001:DB8:ACAD:23::2/64
ipv6 ospf 1 area 3
clock rate 128000
no shutdown
router ospf 1
router-id 2.2.2.2
passive-interface Loopback6
network 192.168.6.0 0.0.0.255 area 3
network 192.168.12.0 0.0.0.3 area 0
network 192.168.23.0 0.0.0.3 area 3
ipv6 router ospf 1
router-id 2.2.2.2
banner motd @
Unauthorized Access is Prohibited! @
line con 0
password cisco
logging synchronous
login
line vty 0 4
password cisco
logging synchronous
login
transport input all
end
```

#### In router 3

```
enable
conf t
hostname R3
no ip domain lookup
ipv6 unicast-routing
enable secret class
interface Loopback4
ip address 192.168.4.1 255.255.255.0
ipv6 address 2001:DB8:ACAD:4::1/64
ipv6 ospf 1 area 3
interface Loopback5
ip address 192.168.5.1 255.255.255.0
ipv6 address 2001:DB8:ACAD:5::1/64
ipv6 ospf 1 area 3
interface Serial0/0/1
ip address 192.168.23.1 255.255.255.252
ipv6 address FE80::3 link-local
ipv6 address 2001:DB8:ACAD:23::1/64
ipv6 ospf 1 area 3
no shutdown
router ospf 1
router-id 3.3.3.3
passive-interface Loopback4
passive-interface Loopback5
network 192.168.4.0 0.0.0.255 area 3
network 192.168.5.0 0.0.0.255 area 3
ipv6 router ospf 1
router-id 3.3.3.3
banner motd @
Unauthorized Access is Prohibited! @
line con 0
password cisco
logging synchronous
login
line vty 0 4
password cisco
logging synchronous
login
transport input all
end
```

### Configuratie IPv4 Controlleren

#### In router 1

```
show run
conf t
int s0/0/0
no ip add
ip add 192.168.12.1 255.255.255.252
end
show run
conf t
int s0/0/0
no shut
end
show run
conf t
router ospf 1
network 192.168.1.0 0.0.0.255 area 1
end
show run
show ip route ospf
show ip ospf neighbor
```

#### In router 2

```
show run

``` 

Alles OK!

#### In router 3

```
show run

```

Netwerk 23.0 moet aanwezig zijn in router ospf 1 config.

```
show ip ospf neighbor
 
```

Geen resultaat!

```
show ip route ospf
```

Geen resultaat!

```
conf t
router ospf 1
network 192.168.23.0 0.0.0.3 area 3
end
show ip ospf neighbor
show ip route ospf
```

Alles is OK nu!

#### In router 1

```
ping 192.168.6.1

```

### Configuratie IPv6 controlleren

#### In router 1

```
show run
```

ipv6 adres loopback 1 bevat een fout!

```
conf t
int lo1
no ipv6 add
ipv6 add 2001:DB8:ACAD:1::1/64
ipv6 ospf 1 area 1
end
show run
```

Router ID is niet aanwezig bij ipv6!

```
conf t
ipv6 router ospf 1
router-id 1.1.1.1
end
show ipv6 protocols
show ipv6 ospf
```

#### In router 2

```
show run
```

Loopback 6 bevat een fout in het ipv6 adres!

```
conf t
int lo6
no ipv6 add 2001:DB8:CAD:6::1/64
ipv6 add 2001:DB8:ACAD:6::1/64
ipv6 ospf 1 area 3
end
show run
```

#### In router 3

```
show run
```

Alles OK!

#### In router 2

```
show ipv6 ospf neighbor
```

#### In router 1

```
ping 2001:db8:acad:6::1
```

De ping lukt niet!

```
show ipv6 route ospf
show ipv6 ospf neighbor
clear ipv6 ospf process
ping 2001:db8:acad:6::1
```

De ping lukt nu wel!

```
ping 2001:db8:acad:5::1
ping 2001:db8:acad:4::1
```

Deze ping-requesten lukken ook zonder probleem.







