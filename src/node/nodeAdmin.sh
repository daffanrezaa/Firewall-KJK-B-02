# DHCP config for PECE ADMIN
auto eth0
iface eth0 inet dhcp

# Static config for Server Admin
auto eth0
iface eth0 inet static
	address 10.20.40.10
	netmask 255.255.255.0
	gateway 10.20.40.1
	up echo nameserver 192.168.122.1 > /etc/resolv.conf

# tes ping
# dari pc ke google
ping 8.8.8.8

# dari pc ke router admin
ping 10.20.40.1