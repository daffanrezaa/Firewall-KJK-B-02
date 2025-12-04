# notes
f0/0 -> Ke Atas (NAT/Internet).
f1/1 -> Ke Kanan (Guest Network).
f1/0 -> Ke Bawah (Core Router).

# config edge router
configure terminal
ip domain-lookup

# --- 2. Setting Interface ke INTERNET (Atas) ---
interface FastEthernet0/0
 description JALUR_INTERNET
 ip address dhcp
 ip nat outside
 no shutdown
 exit

# --- 3. Setting Interface ke GUEST (Kanan) ---
interface FastEthernet1/1
 description GATEWAY_GUEST
 ip address 10.20.50.1 255.255.255.0
 ip nat inside
 no shutdown
 exit

# --- 4. Setting Interface ke CORE ROUTER (Bawah) ---
interface FastEthernet1/0
 description JALUR_KE_CORE
 ip address 10.20.99.1 255.255.255.252
 ip nat inside
 no shutdown
 exit

# ! --- Tambahkan DHCP Pool Guest ---
ip dhcp pool POOL_GUEST
 network 10.20.50.0 255.255.255.0
 default-router 10.20.50.1
 no dns-server 8.8.8.8
 dns-server 192.168.122.1
 exit

# --- 5. Setting Routing OSPF (Agar Core tau jalan ke Internet) ---
router ospf 1
 # Kenalkan jaringan Guest
 network 10.20.50.0 0.0.0.255 area 0
 # Kenalkan jalur penghubung Core
 network 10.20.99.0 0.0.0.3 area 0
 # Sebarkan informasi "Saya punya Internet" ke router bawah
 default-information originate
 exit

# --- 6. Setting NAT (Agar semua PC bisa browsing) ---
# Izinkan semua IP 10.20.x.x untuk pakai NAT
access-list 1 permit 10.20.0.0 0.0.255.255
# Aktifkan NAT Overload (Masquerade) ke arah Internet
ip nat inside source list 1 interface FastEthernet0/0 overload

# --- 7. Simpan Konfigurasi Permanen ---
end
write

# testing di EdgeRouter
ping 8.8.8.8


#perbaikan edgerouter yang tidak bisa download 
enable
configure terminal

! 1. Pastikan interface NAT sudah benar
interface FastEthernet0/0
 ip nat outside
 exit

interface FastEthernet1/0
 ip nat inside
 exit

interface FastEthernet1/1
 ip nat inside
 exit

! 2. Buat access-list untuk NAT (izinkan semua 10.20.x.x)
access-list 1 permit 10.20.0.0 0.0.255.255

! 3. Aktifkan NAT Overload
ip nat inside source list 1 interface FastEthernet0/0 overload

end
write

## Verifikasi
show statisticsip nat 
show run | include nat


##Test dari Guest
Setelah NAT diperbaiki, coba lagi di Guest-1:
ping -c 2 8.8.8.8
ping -c 2 google.com
