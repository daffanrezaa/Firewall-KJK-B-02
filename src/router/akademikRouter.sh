# notes:
f0/0 (Ke Atas/Core): 10.20.99.10 
f1/0 (Ke Bawah/LAN): 10.20.20.1 

# config akademikRouter
enable
configure terminal
hostname AkademikRouter
ip domain-lookup

# ! --- 1. Jalur ke ATAS (Ke Core) ---
interface FastEthernet0/0
 description LINK_TO_CORE
 # ! IP pasangannya Core (.9)
 ip address 10.20.99.10 255.255.255.252
 no shutdown
 exit

# ! --- 2. Jalur ke BAWAH (LAN Akademik) ---
interface FastEthernet1/0
 description LAN_AKADEMIK
 ip address 10.20.20.1 255.255.255.0
 no shutdown
 exit

# ! --- 3. Routing OSPF ---
router ospf 1
 # ! Kenalkan subnet penghubung
 network 10.20.99.8 0.0.0.3 area 0
 # ! Kenalkan subnet Akademik
 network 10.20.20.0 0.0.0.255 area 0
 exit

# ! --- 4. DHCP Server (Hanya untuk PC Staff) ---
ip dhcp pool POOL_AKADEMIK
 network 10.20.20.0 255.255.255.0
 default-router 10.20.20.1
 no dns-server 8.8.8.8
 dns-server 192.168.122.1
 exit

#! --- Simpan ---
end
write