### Testplan

### Testrapport

Testen uitgevoerd in PacketTracer 6.2 voor Linux  
(Stappenplan gevolgd)

#### Stap 1 en 2: basisconfiguratie, VLAN's, trunks

##### S1

Output van show vlan brief op S1: alle VLANs zijn aanwezig en juist geconfigureerd

        VLAN Name                             Status    Ports
        ---- -------------------------------- --------- -------------------------------
        1    default                          active    Fa0/2, Fa0/4, Fa0/5, Fa0/7
                                                        Fa0/8, Fa0/9, Fa0/10, Fa0/11
                                                        Fa0/12, Fa0/13, Fa0/14, Fa0/15
                                                        Fa0/16, Fa0/17, Fa0/18, Fa0/19
                                                        Fa0/20, Fa0/21, Fa0/22, Fa0/23
                                                        Fa0/24, Gig0/1, Gig0/2
        10   User                             active    Fa0/6
        99   Management                       active    
        1002 fddi-default                     active    
        1003 token-ring-default               active    
        1004 fddinet-default                  active    
        1005 trnet-default                    active

Output van show interfaces trunk op S1: alle trunklijnen zijn correct geconfigureerd

        S1#show int trun
        Port        Mode         Encapsulation  Status        Native vlan
        Fa0/1       on           802.1q         trunking      99
        Fa0/3       on           802.1q         trunking      99

        Port        Vlans allowed on trunk
        Fa0/1       1-1005
        Fa0/3       1-1005

        Port        Vlans allowed and active in management domain
        Fa0/1       1,10,99
        Fa0/3       1,10,99

        Port        Vlans in spanning tree forwarding state and not pruned
        Fa0/1       1,10,99
        Fa0/3       1,10,99

Output van show running-config op S1: alle interfaces zijn correct geconfigureerd

        !
        interface FastEthernet0/1
         switchport trunk native vlan 99
         switchport mode trunk
        !
        interface FastEthernet0/2
         shutdown
        !
        interface FastEthernet0/3
         switchport trunk native vlan 99
         switchport mode trunk
        !
        ...
        !
        interface FastEthernet0/6
         switchport access vlan 10
         switchport mode access
        !
        ...
        !
        interface Vlan99
         ip address 192.168.1.11 255.255.255.0
        !


##### S2

Output van show vlan brief op S2: alle VLANs zijn aanwezig en juist geconfigureerd

        VLAN Name                             Status    Ports
        ---- -------------------------------- --------- -------------------------------
        1    default                          active    Fa0/2, Fa0/4, Fa0/5, Fa0/6
                                                        Fa0/7, Fa0/8, Fa0/9, Fa0/10
                                                        Fa0/11, Fa0/12, Fa0/13, Fa0/14
                                                        Fa0/15, Fa0/16, Fa0/17, Fa0/19
                                                        Fa0/20, Fa0/21, Fa0/22, Fa0/23
                                                        Fa0/24, Gig0/1, Gig0/2
        10   User                             active    Fa0/18
        99   Management                       active    
        1002 fddi-default                     active    
        1003 token-ring-default               active    
        1004 fddinet-default                  active    
        1005 trnet-default                    active  

Output van show interfaces trunk op S2: alle trunklijnen zijn correct geconfigureerd

        Port        Mode         Encapsulation  Status        Native vlan
        Fa0/1       on           802.1q         trunking      99
        Fa0/3       on           802.1q         trunking      99

        Port        Vlans allowed on trunk
        Fa0/1       1-1005
        Fa0/3       1-1005

        Port        Vlans allowed and active in management domain
        Fa0/1       1,10,99
        Fa0/3       1,10,99

        Port        Vlans in spanning tree forwarding state and not pruned
        Fa0/1       1,10,99
        Fa0/3       1,10,99

Output van show running-config op S2: alle interfaces zijn correct geconfigureerd

        spanning-tree mode pvst
        !
        interface FastEthernet0/1
         switchport trunk native vlan 99
         switchport mode trunk
        !
        interface FastEthernet0/3
         switchport trunk native vlan 99
         switchport mode trunk
        !
        ...
        !
        interface FastEthernet0/18
         switchport access vlan 10
         switchport mode access
        !
        ...
        !
        interface Vlan99
         ip address 192.168.1.13 255.255.255.0
        !

##### S3

Output van show vlan brief op S3: alle VLANs zijn aanwezig en juist geconfigureerd

        VLAN Name                             Status    Ports
        ---- -------------------------------- --------- -------------------------------
        1    default                          active    Fa0/2, Fa0/4, Fa0/5, Fa0/6
                                                        Fa0/7, Fa0/8, Fa0/9, Fa0/10
                                                        Fa0/11, Fa0/12, Fa0/13, Fa0/14
                                                        Fa0/15, Fa0/16, Fa0/17, Fa0/18
                                                        Fa0/19, Fa0/20, Fa0/21, Fa0/22
                                                        Fa0/23, Fa0/24, Gig0/1, Gig0/2
        10   User                             active    
        99   Management                       active    
        1002 fddi-default                     active    
        1003 token-ring-default               active    
        1004 fddinet-default                  active    
        1005 trnet-default                    active  

Output van show interfaces trunk op S3: alle trunklijnen zijn correct geconfigureerd

        Port        Mode         Encapsulation  Status        Native vlan
        Fa0/1       on           802.1q         trunking      99
        Fa0/3       on           802.1q         trunking      99

        Port        Vlans allowed on trunk
        Fa0/1       1-1005
        Fa0/3       1-1005

        Port        Vlans allowed and active in management domain
        Fa0/1       1,10,99
        Fa0/3       1,10,99

        Port        Vlans in spanning tree forwarding state and not pruned
        Fa0/1       none
        Fa0/3       1,10,99

Output van show running-config op S3: alle interfaces zijn correct geconfigureerd

        !
        interface FastEthernet0/1
         switchport trunk native vlan 99
         switchport mode trunk
        !
        interface FastEthernet0/2
         shutdown
        !
        interface FastEthernet0/3
         switchport trunk native vlan 99
         switchport mode trunk
        !
        ...
        !
        interface Vlan99
         ip address 192.168.1.12 255.255.255.0
        !

#### Stap 3: configuratie root bridge

##### S1

Output van show spanning-tree toont dat root bridge geconfigureerd is en de poorten de juiste link types hebben (alleen output VLAN10 getoond):

        VLAN0010
          Spanning tree enabled protocol rstp
          Root ID    Priority    20490
                     Address     0060.7087.94AE
                     Cost        19
                     Port        1(FastEthernet0/1)
                     Hello Time  2 sec  Max Age 20 sec  Forward Delay 15 sec

          Bridge ID  Priority    28682  (priority 28672 sys-id-ext 10)
                     Address     0001.4397.59C5
                     Hello Time  2 sec  Max Age 20 sec  Forward Delay 15 sec
                     Aging Time  20

        Interface        Role Sts Cost      Prio.Nbr Type
        ---------------- ---- --- --------- -------- --------------------------------
        Fa0/6            Desg FWD 19        128.6    P2p
        Fa0/1            Root FWD 19        128.1    P2p
        Fa0/3            Altn BLK 19        128.3    P2p

##### S2

Output van show spanning-tree toont dat deze switch de root bridge is, alle poorten zijn designated ports:

        VLAN0010
          Spanning tree enabled protocol rstp
          Root ID    Priority    20490
                     Address     0060.7087.94AE
                     This bridge is the root
                     Hello Time  2 sec  Max Age 20 sec  Forward Delay 15 sec

          Bridge ID  Priority    20490  (priority 20480 sys-id-ext 10)
                     Address     0060.7087.94AE
                     Hello Time  2 sec  Max Age 20 sec  Forward Delay 15 sec
                     Aging Time  20

        Interface        Role Sts Cost      Prio.Nbr Type
        ---------------- ---- --- --------- -------- --------------------------------
        Fa0/1            Desg FWD 19        128.1    P2p
        Fa0/3            Desg FWD 19        128.3    P2p

##### S3

Output van show spanning-tree

        VLAN0010
          Spanning tree enabled protocol rstp
          Root ID    Priority    20490
                     Address     0060.7087.94AE
                     Cost        19
                     Port        1(FastEthernet0/1)
                     Hello Time  2 sec  Max Age 20 sec  Forward Delay 15 sec

          Bridge ID  Priority    24586  (priority 24576 sys-id-ext 10)
                     Address     0000.0C56.97C1
                     Hello Time  2 sec  Max Age 20 sec  Forward Delay 15 sec
                     Aging Time  20

        Interface        Role Sts Cost      Prio.Nbr Type
        ---------------- ---- --- --------- -------- --------------------------------
        Fa0/1            Root FWD 19        128.1    P2p
        Fa0/3            Desg FWD 19        128.3    P2p
        Fa0/18           Desg FWD 19        128.18   P2p

#### Stap 4: Rapid PVST+, PortFast, BPDUGuard

(Getest met show running-config aangezien pipes niet kunnen in PT)

##### S1

        Show run toont dat rapid-PVST+, PortFast en BPDUGuard actief zijn:

        !
        spanning-tree mode rapid-pvst
        spanning-tree vlan 1,10,99 priority 28672
        !
        ...
        !
        interface FastEthernet0/6
         switchport access vlan 10
         switchport mode access
         spanning-tree portfast
         spanning-tree bpduguard enable
        !

##### S2

        !
        spanning-tree mode rapid-pvst
        spanning-tree vlan 1,10,99 priority 24576
        !

##### S3

probleem: commando's niet herkend (configuratie bpduguard op alle access ports)

- (config) spanning-tree bpduguard (stappenplan)
- (config) spanning-tree portfast bpduguard default (cursus Cisco)

Commando spanning-tree bpduguard enable uitgevoerd voor interface fa0/18.

        !
        spanning-tree mode rapid-pvst
        spanning-tree portfast default
        spanning-tree vlan 1,10,99 priority 24576
        !
        ...
        !
        interface FastEthernet0/18
         switchport access vlan 10
         switchport mode access
         spanning-tree bpduguard enable
        !
