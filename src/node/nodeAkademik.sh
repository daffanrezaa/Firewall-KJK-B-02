# DHCP config for eth0
auto eth0
iface eth0 inet dhcp

# Static config untuk Database
auto eth0
iface eth0 inet static
	address 10.20.20.10
	netmask 255.255.255.0
	gateway 10.20.20.1
	up echo nameserver 192.168.122.1 > /etc/resolv.conf

# tes ping
# dari pc ke google
ping 8.8.8.8

# dari pc ke db-akademik
ping 10.20.20.3

