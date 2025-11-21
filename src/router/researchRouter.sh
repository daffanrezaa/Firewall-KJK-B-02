# notes:
f0/0 (Ke Atas/Core): 10.20.99.14
f1/0 (Ke Bawah/LAN): 10.20.30.1 

enable
configure terminal
hostname ResearchRouter
ip domain-lookup

# ! --- 1. Jalur ke ATAS (Ke Core) ---
interface FastEthernet0/0
 description LINK_TO_CORE
 ip address 10.20.99.14 255.255.255.252
 no shutdown
 exit

# ! --- 2. Jalur ke BAWAH (LAN Riset) ---
interface FastEthernet1/0
 description LAN_RISET
 ip address 10.20.30.1 255.255.255.0
 no shutdown
 exit

# ! --- 3. Routing OSPF ---
router ospf 1
 network 10.20.99.12 0.0.0.3 area 0
 network 10.20.30.0 0.0.0.255 area 0
 exit

# ! --- (Opsional) DHCP Server ---
# ! Kita tetap buat jaga-jaga kalau ada laptop mahasiswa yang mau connect ke WiFi Lab Riset
ip dhcp pool POOL_RISET
 network 10.20.30.0 255.255.255.0
 default-router 10.20.30.1
 no dns-server 8.8.8.8
 dns-server 192.168.122.1
 exit

# ! --- Simpan ---
end
write