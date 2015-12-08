#Stappenplan Cisco Labo 7.4.3.4: Configuring Basic EIGRP with IPV6

#####1. Enable Ipv6 on each router

######1.1 R1
<pre>
en
conf t
ipv6 unicast-routing
</pre>

######1.2 R2
<pre>
en  
conf t
ipv6 unicast-routing
</pre>

######1.3 R3
<pre>
en
conf t
ipv6 unicast-routing
</pre>

#####2. Enable EIGRP on each router

######2.1 R1
<pre>
ipv6 router eigrp 1
no shutdown
eigrp router-id 1.1.1.1
exit
int g0/0
ipv6 eigrp 1
int s0/0/0
ipv6 eigrp 1
int s0/0/1
ipv6 eigrp 1
</pre>

######2.2 R2
<pre>
ipv6 router eigrp 1
no shutdown
eigrp router-id 2.2.2.2
exit
int g0/0
ipv6 eigrp 1
int s0/0/0
ipv6 eigrp 1
int s0/0/1
ipv6 eigrp 1
</pre>

######2.3 R3
<pre>
ipv6 router eigrp 1
no shutdown
eigrp router-id 3.3.3.3
exit
int g0/0
ipv6 eigrp 1
int s0/0/0
ipv6 eigrp 1
int s0/0/1
ipv6 eigrp 1
</pre>

#####3. Examine neighbor adjacencies
<pre>
show ipv6 eigrp neighbors
</pre>

#####4. Examine IPV6 EIGRP routing table
<pre>
show ipv6 route
</pre>

#####5. Verify parameters
<pre>
show ipv6 protocols
</pre>

#####6. Verifiy connectivity
Ping between the hosts