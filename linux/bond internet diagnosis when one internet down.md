# Background

When gathering server hardware information, bond0 ethernet speed is abnormal.

# Process

Check bond0 ethernet speed

```text
[root@namenode2 network-scripts]# ethtool bond0
Settings for bond0:
	Supported ports: [ ]
	Supported link modes:   Not reported
	Supported pause frame use: No
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  Not reported
	Advertised pause frame use: No
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Speed: 10000Mb/s  <==== Here, should be 20000Mb/s
	Duplex: Full
	Port: Other
	PHYAD: 0
	Transceiver: internal
	Auto-negotiation: off
	Link detected: yes
```

Check bond0 Ethernet status

```text
[root@namenode2 network-scripts]# cat /proc/net/bonding/bond0 
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: load balancing (round-robin)
MII Status: up
MII Polling Interval (ms): 1
Up Delay (ms): 0
Down Delay (ms): 0

Slave Interface: p1p1
MII Status: down
Speed: Unknown
Duplex: Unknown
Link Failure Count: 0
Permanent HW addr: f8:f2:1e:ad:48:c0
Slave queue ID: 0

Slave Interface: em1
MII Status: up
Speed: 10000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: e4:43:4b:eb:b5:54
Slave queue ID: 0

Slave Interface: p1p2
MII Status: up
Speed: 10000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: f8:f2:1e:ad:48:c1
Slave queue ID: 0
```

Check status of all ethernets related to bond0

```text
[root@namenode2 network-scripts]# ethtool em1
Settings for em1:
	Supported ports: [ FIBRE ]
	Supported link modes:   10000baseT/Full 
	Supported pause frame use: Symmetric
	Supports auto-negotiation: No
	Supported FEC modes: Not reported
	Advertised link modes:  10000baseT/Full 
	Advertised pause frame use: No
	Advertised auto-negotiation: No
	Advertised FEC modes: Not reported
	Speed: 10000Mb/s
	Duplex: Full
	Port: FIBRE
	PHYAD: 0
	Transceiver: internal
	Auto-negotiation: off
	Supports Wake-on: g
	Wake-on: g
	Current message level: 0x00000007 (7)
			       drv probe link
	Link detected: yes
```

If speed field is not null, it illuminates the inet has connected the switcher.
Check inets one by one

Commonly, bonding ethernet should be up.
```text
[root@namenode2 network-scripts]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: em1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000 <===========
    link/ether e4:43:4b:eb:b5:54 brd ff:ff:ff:ff:ff:ff
3: em3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether e4:43:4b:eb:b5:74 brd ff:ff:ff:ff:ff:ff
4: em2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether e4:43:4b:eb:b5:56 brd ff:ff:ff:ff:ff:ff
5: em4: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether e4:43:4b:eb:b5:75 brd ff:ff:ff:ff:ff:ff
6: p1p1: <BROADCAST,MULTICAST,SLAVE> mtu 1500 qdisc mq master bond0 state DOWN group default qlen 1000 ##### will be removed after server restarted
    link/ether e4:43:4b:eb:b5:54 brd ff:ff:ff:ff:ff:ff
7: p1p2: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000 <===========
    link/ether e4:43:4b:eb:b5:54 brd ff:ff:ff:ff:ff:ff
8: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether e4:43:4b:eb:b5:54 brd ff:ff:ff:ff:ff:ff
    inet 10.50.253.222/32 scope global bond0
       valid_lft forever preferred_lft forever
    inet 10.50.253.7/24 brd 10.50.253.255 scope global bond0
       valid_lft forever preferred_lft forever
    inet6 fe80::e643:4bff:feeb:b554/64 scope link 
       valid_lft forever preferred_lft forever
```

If we modify network configuration file, issue `ifup network ; ifdown network` to take effect, which `network` may be em1 or bond0.

At last, issue `cat /proc/net/bonding/bond0` and `ethtool bond0` to check bond0 status.