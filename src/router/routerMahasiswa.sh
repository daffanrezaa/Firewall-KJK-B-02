enable
configure terminal
hostname RouterMahasiswa
no ip domain-lookup

# ! --- 1. Setting Jalur ke ATAS (Ke CoreRouter) ---
# ! Core pakai 10.20.99.5, jadi kita pakai pasangannya (.6)
interface FastEthernet0/0
 description LINK_TO_CORE
 ip address 10.20.99.6 255.255.255.252
 no shutdown
 exit

# ! --- 2. Setting Jalur ke BAWAH (LAN Mahasiswa) ---
# ! Gateway untuk PC Mahasiswa
interface FastEthernet1/0
 description LAN_MAHASISWA
 ip address 10.20.10.1 255.255.255.0
 no shutdown
 exit

# ! --- 3. Setting Routing OSPF ---
# ! Agar bisa ngobrol sama Core & Edge
router ospf 1
 network 10.20.99.4 0.0.0.3 area 0
 network 10.20.10.0 0.0.0.255 area 0
 exit

# ! --- 4. Setting DHCP Server (Otomatisasi IP PC) ---
# ! Biar PC Mahasiswa tinggal colok langsung connect
ip dhcp pool POOL_MHS
 network 10.20.10.0 255.255.255.0
 default-router 10.20.10.1
 dns-server 8.8.8.8
 exit

# ! --- Simpan ---
end
write

# Tes ping 
# ke coreRouter
ping 10.20.99.5

# ke internet
ping 8.8.8.8