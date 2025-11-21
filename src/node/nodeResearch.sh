# Static config for Web Server
auto eth0
iface eth0 inet static
	address 10.20.30.10
	netmask 255.255.255.0
	gateway 10.20.30.1
	up echo nameserver 192.168.122.1 > /etc/resolv.conf

# DHCP for Research Device
auto eth0
iface eth0 inet dhcp


# tes ping
# dari pc ke google
ping 8.8.8.8

# dari pc ke webserver
ping 10.20.30.10