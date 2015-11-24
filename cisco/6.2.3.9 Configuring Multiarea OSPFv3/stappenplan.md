- 3 Cisco 1941 routers maken

- Tussen R1 en R2, en R2 en R3 seriële verbindingen maken.

- Voor R1 en R3 elk een area maken.

- Voor R2 een groot area maken

#### In router 1

en
conf t
hostname R1
int s0/0/0
ipv6 address 2001:db8:acad:12::1/64
ipv6 address fe80::1 link-local
clock rate 128000
no shutdown
int lo0
ipv6 address 2001:db8:acad::1/64
int lo1
ipv6 address 2001:db8:acad:1::1/64
int lo2
ipv6 address 2001:db8:acad:2::1/64
int lo3
ipv6 address 2001:db8:acad:3::1/64
exit
ipv6 unicast-routing
end
sh run conf

#### in router 2

en
conf t
hostname R2
int s0/0/0
ipv6 address 2001:db8:acad:12::2/64
ipv6 address fe80::2 link-local
no shutdown
int s0/0/1
ipv6 address 2001:db8:acad:23::3/64
ipv6 address fe80::3 link-local
clock rate 128000
no shutdown
int lo8
ipv6 address 2001:db8:acad:8::1/64
exit
ipv6 unicast-routing
end

#### In router 3

en
conf t
hostname R3
int s0/0/1
ipv6 address 2001:db8:acad:23::3/64
ipv6 address fe80::3 link-local
no shutdown
int lo4
ipv6 address 2001:db8:acad:4::1/64
int lo5
ipv6 address 2001:db8:acad:5::1/64
int lo6
ipv6 address 2001:db8:acad:6::1/64
int lo7
ipv6 address 2001:db8:acad:7::1/64
exit
ipv6 unicast-routing

#### In router 2

ping 2001:db8:acad:12::1
ping 2001:db8:acad:23::3

#### In router 1

conf t
ipv6 router ospf 1
router-id 1.1.1.1

#### In router 2

conf t
ipv6 router ospf 1
router-id 2.2.2.2

#### In router 3

conf t
ipv6 router ospf 1
router-id 3.3.3.3
show ipv6 ospf

#### In router 1

int lo0
ipv6 ospf 1 area 1
ipv6 ospf network point-to-point
int lo1
ipv6 ospf 1 area 1
ipv6 ospf network point-to-point
int lo2
ipv6 ospf 1 area 1
ipv6 ospf network point-to-point
int lo3
ipv6 ospf 1 area 1
ipv6 ospf network point-to-point
int s0/0/0
ipv6 ospf 1 area 0
show ipv6 protocols

#### In router 2

int lo8
ipv6 ospf 1 area 0
ipv6 ospf network point-to-point
int s0/0/0
ipv6 ospf 1 area 0
int s0/0/1
ipv6 ospf 1 area 0
exit
show ipv6 ospf interface
show ipv6 ospf neighbor

#### In router 3

conf t
int lo4
ipv6 ospf 1 area 2
ipv6 ospf network point-to-point
int lo5
ipv6 ospf 1 area 2
ipv6 ospf network point-to-point
int lo6
ipv6 ospf 1 area 2
ipv6 ospf network point-to-point
int lo7
ipv6 ospf 1 area 2
ipv6 ospf network point-to-point
int s0/0/1
ipv6 ospf 1 area 0
exit
exit
show ipv6 ospf

#### In router 1

show ipv6 ospf neighbor
show ipv6 route ospf
show ipv6 route
show ipv6 ospf database

#### In router 2

show ipv6 ospf database

#### In router 1

conf t
ipv6 router ospf 1
area 1 range 2001:db8:acad::/62
show ipv6 route ospf

#### In router 3

show ipv6 route ospf

#### In router 1

show ipv6 route ospf





















