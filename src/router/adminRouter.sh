# notes
f0/0 (Ke Atas/Core): 10.20.99.18 
f1/0 (Ke Bawah/LAN): 10.20.40.1

# config adminRouter
enable
configure terminal
hostname AdminRouter
no ip domain-lookup

# ! --- 1. Jalur ke ATAS (Ke Core) ---
interface FastEthernet0/0
 description LINK_TO_CORE
 ip address 10.20.99.18 255.255.255.252
 no shutdown
 exit

# ! --- 2. Jalur ke BAWAH (LAN Admin) ---
interface FastEthernet1/0
 description LAN_ADMIN
 ip address 10.20.40.1 255.255.255.0
 no shutdown
 exit

# ! --- 3. Routing OSPF ---
router ospf 1
 # ! Kenalkan subnet penghubung
 network 10.20.99.16 0.0.0.3 area 0
 # ! Kenalkan subnet Admin
 network 10.20.40.0 0.0.0.255 area 0
 exit

# ! --- 4. DHCP Server (Untuk PC Admin) ---
ip dhcp pool POOL_ADMIN
 network 10.20.40.0 255.255.255.0
 default-router 10.20.40.1
 dns-server 8.8.8.8
 exit

# ! --- Simpan ---
end
write