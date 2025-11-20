# Notes:
f0/0 (Ke Atas/Edge): 10.20.99.2
f1/0 (Ke Mahasiswa): 10.20.99.5 
f1/1 (Ke Akademik): 10.20.99.9 
f2/0 (Ke Riset): 10.20.99.13 
f2/1 (Ke Admin): 10.20.99.17 

# config core router
enable
configure terminal
hostname CoreRouter-Firewall
no ip domain-lookup

# ! --- 1. KONFIGURASI IP ADDRESS ---

# ! Ke Arah Edge (Uplink)
interface FastEthernet0/0
 description LINK_TO_EDGE
 ip address 10.20.99.2 255.255.255.252
 no shutdown
 exit

# ! Ke Arah Mahasiswa
interface FastEthernet1/0
 description LINK_TO_MHS
 ip address 10.20.99.5 255.255.255.252
 no shutdown
 exit

# ! Ke Arah Akademik
interface FastEthernet1/1
 description LINK_TO_AKADEMIK
 ip address 10.20.99.9 255.255.255.252
 no shutdown
 exit

# ! Ke Arah Riset (Perhatikan interface f2/0 sesuai gambar)
interface FastEthernet2/0
 description LINK_TO_RISET
 ip address 10.20.99.13 255.255.255.252
 no shutdown
 exit

# ! Ke Arah Admin (Perhatikan interface f2/1 sesuai gambar)
interface FastEthernet2/1
 description LINK_TO_ADMIN
 ip address 10.20.99.17 255.255.255.252
 no shutdown
 exit


# ! --- 2. KONFIGURASI ROUTING (OSPF) ---
router ospf 1
 # ! Kenalkan semua network 10.20.x.x yang terhubung
 network 10.20.0.0 0.0.255.255 area 0
 exit


#! --- 3. KONFIGURASI FIREWALL (ACL) ---

# ! A. Rule Blokir GUEST (Dipasang di pintu atas f0/0)
# ! Logika: Kalau ada paket dari Guest (10.20.50.x) mau masuk ke Internal -> TOLAK
ip access-list extended BLOCK_GUEST
 deny ip 10.20.50.0 0.0.0.255 10.20.0.0 0.0.255.255
 permit ip any any

#! B. Rule Batasi MAHASISWA (Dipasang di pintu f1/0)
# ! Logika: Mhs gaboleh ke Admin & gaboleh ke DB Akademik
ip access-list extended FILTER_MHS
 deny ip any 10.20.40.0 0.0.0.255
 # ! (IP DB Akademik nanti kita set 10.20.20.10)
 deny tcp any host 10.20.20.10 eq 3306
 permit ip any any

# ! C. Rule Batasi UMUM (Akademik & Riset)
# ! Logika: Gaboleh ke Admin, sisanya bebas
ip access-list extended PROTECT_ADMIN
 deny ip any 10.20.40.0 0.0.0.255
 permit ip any any


# ! --- 4. MENERAPKAN ACL KE PINTU (INTERFACE) ---

# ! Terapkan di Pintu Atas (Dari Edge masuk ke Core)
interface FastEthernet0/0
 ip access-group BLOCK_GUEST in
 exit

# ! Terapkan di Pintu Mahasiswa
interface FastEthernet1/0
 ip access-group FILTER_MHS in
 exit

# ! Terapkan di Pintu Akademik
interface FastEthernet1/1
 ip access-group PROTECT_ADMIN in
 exit

# ! Terapkan di Pintu Riset
interface FastEthernet2/0
 ip access-group PROTECT_ADMIN in
 exit

# ! (Pintu Admin f2/1 TIDAK dikasih ACL, biar Admin bebas akses kemana aja)

# ! --- Simpan ---
end
write

# test di Core, ping Edge
ping 10.20.99.1