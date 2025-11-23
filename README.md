# Laporan Proyek Jaringan Komputer
## Kelompok 2 - Kelas B
**Desain Keamanan Jaringan Kampus**

Dokumentasi implementasi topologi jaringan kampus menggunakan GNS3, Cisco Router, dan Docker Container.

## Anggota Kelompok

| NRP | Nama | 
| :--- | :--- |
| 5027241007 | Revalina Erica Permatasari | 
| 5027241034 | Aditya Reza Daffansyah |
| 5027241064 | Hanif Mawla Faizi |
| 5027241088 | I Gede Bagus Saka Sinatrya |
| 5027241116 | Putri Joselina Silitonga | 
---

## Desain Topologi

![Masukkan Screenshot Topologi GNS3 Disini](/assets/topologi.png)

### Skema IP Address (IP Plan)

Kami menggunakan blok IP 10.20.0.0/16 dengan pembagian subnet sebagai berikut:

| Zona | Subnet Network | Gateway | Konfigurasi IP |
| :--- | :--- | :--- | :--- |
| Backbone (Router-to-Router) | 10.20.99.0/30 | - | Static |
| Guest Network | 10.20.50.0/24 | 10.20.50.1 | DHCP |
| Mahasiswa LAN | 10.20.10.0/24 | 10.20.10.1 | DHCP |
| Akademik LAN | 10.20.20.0/24 | 10.20.20.1 | DHCP (PC) / Static (DB) |
| Riset & IoT LAN | 10.20.30.0/24 | 10.20.30.1 | DHCP (PC) / Static (Server) |
| Admin LAN | 10.20.40.0/24 | 10.20.40.1 | DHCP (PC) / Static (Server) |

---

## Konfigurasi Jaringan

### 1. Routing Protocol
Routing dinamis menggunakan **OSPF (Open Shortest Path First)** area 0 untuk menghubungkan seluruh router cabang dengan Core Router dan Edge Router.

### 2. Layanan Jaringan
* **NAT (Network Address Translation):** Dikonfigurasi pada Edge Router untuk akses internet.
* **DHCP Server:** Dikonfigurasi pada masing-masing router cabang (Mahasiswa, Akademik, Riset, Admin, dan Guest) untuk distribusi IP otomatis ke klien.

---

## Implementasi Keamanan (Firewall)

Keamanan diterapkan menggunakan **Cisco Extended ACL** pada Core Router untuk membatasi lalu lintas antar-zona.

**Aturan Akses (Ruleset):**

1.  **Guest Isolation:**
    * Guest dilarang mengakses seluruh jaringan internal (10.20.0.0/16).
    * Guest diizinkan mengakses Internet.

2.  **Pembatasan Mahasiswa:**
    * Block akses ke Subnet Admin.
    * Block akses ke Database Akademik (Port 3306).
    * Allow akses ke Web Server Riset (Port 80) dan Internet.

3.  **Proteksi Admin:**
    * Subnet Admin tidak boleh diakses oleh zona manapun (kecuali return traffic).

---

# 1. Keamanan yang Seimbang untuk Jaringan Kampus

## Definisi Keamanan
Keamanan yang seimbang untuk jaringan kampus adalah kebijakan yang melindungi data sensitif tanpa menghalangi kolaborasi antar departemen. Sistem keamanan harus cukup ketat untuk mencegah serangan, namun fleksibel untuk mendukung interaksi antar stakeholder (mahasiswa, akademik, admin).

## Akses yang Diperbolehkan

### Mahasiswa:
- **Akses**: Web server riset (Port 80) dan internet.
- **Dilarang**: Akses ke subnet Admin dan database akademik.

### Akademik:
- **Akses**: Server riset, database akademik.
- **Dilarang**: Akses ke subnet Admin.

### Admin:
- **Akses**: Hanya dapat diakses oleh petugas admin dengan pengaturan sangat ketat.
- **Dilarang**: Akses dari zona lainnya, kecuali return traffic.

### Riset & IoT:
- **Akses**: Server riset dan internet.
- **Dilarang**: Akses ke subnet Admin dan database akademik.

## Kebijakan Keamanan
- **Guest Network**: Terisolasi dari jaringan internal, hanya diizinkan mengakses internet.
  - **ACL**: `Dilarang mengakses jaringan internal (10.20.0.0/16)`, hanya boleh mengakses **internet**.
  
- **ACL dan Firewall**:
  - Menggunakan **Cisco Extended ACL** untuk membatasi akses antar subnet, memastikan perlindungan maksimal tanpa menghambat kolaborasi.
  - Mengizinkan akses hanya ke layanan yang relevan untuk masing-masing departemen.

# 2. Pertahanan Berlapis untuk Mengatasi Serangan Internal

**Serangan yang Diuji:**
1. **Port Scanning** (Guest dan Mahasiswa)
2. **Brute Force SSH**
3. **Database Access Attempt**
4. **DoS (SYN Flood, ICMP Flood)**
5. **Traceroute, Fragmentation Attacks**

**Desain Sistem Pertahanan Berlapis:**

1. **Perimeter**:  
   **Firewall** dan **Cisco ACL** untuk mengisolasi **Guest** dan membatasi akses **Mahasiswa** dan **Akademik** ke **Admin** dan **Database Akademik**.  
   - **Hasil Uji**: Port scanning dari **Guest** dan **Mahasiswa** diblokir, akses ke **Internet** diizinkan.

2. **Deteksi**:  
   **IDS** untuk mendeteksi **port scanning**, **SYN flood**, dan **ICMP flood**.  
   - **Hasil Uji**: **SYN flood** dan **Traceroute** ke **Admin** diblokir.

3. **Mitigasi**:  
   **Rate Limiting** dan **Firewall** untuk mencegah **DoS**.  
   - **Hasil Uji**: **SYN flood** ke **Admin** diblokir, **ICMP flood** dibatasi.

4. **Perlindungan Akses**:  
   **Autentikasi dua faktor** dan **least privilege** untuk akses ke **Admin**, **Database**, dan **Server Riset**.  
   - **Hasil Uji**: **SSH Brute Force** dan **Database Access Attempts** diblokir.

**Bukti dan Hasil Simulasi**:  
Uji coba menunjukkan bahwa serangan seperti **port scanning**, **DoS**, dan **SSH brute force** berhasil diblokir sesuai dengan kebijakan **ACL** dan **Firewall** yang diterapkan.

1. **Port Scanning** :
   - Attack 1 : Scan ke server admin
     
     <img width="600" height="238" alt="Screenshot 2025-11-23 203517" src="https://github.com/user-attachments/assets/303a1dd9-f02a-4ab6-89f9-0683253e2c7c" />

   - Attack 2 : Scan ke server riset
     
     <img width="598" height="197" alt="Screenshot 2025-11-23 203556" src="https://github.com/user-attachments/assets/70134329-b3ce-4e32-a2e8-04df9269a804" />


2. **DoS** :
   - Attack 1 : SYN flood ke Admin server
     
     <img width="552" height="144" alt="Screenshot 2025-11-23 203730" src="https://github.com/user-attachments/assets/35e1659e-dec3-4b0d-848d-5a00792230b1" />

   - Attack 2 : SYN flood ke DB port 3306
     
     <img width="565" height="138" alt="Screenshot 2025-11-23 203755" src="https://github.com/user-attachments/assets/f0894e00-2dc3-425e-a613-9798590ac693" />

3. **SSH Brute Force** :
   - Attack 1 : SSH ke DB Akademik
     
     <img width="565" height="98" alt="Screenshot 2025-11-23 203858" src="https://github.com/user-attachments/assets/58602807-a262-412f-bc55-5f765b181403" />

   - Attack 2 : SSH ke Server Admin
     
      <img width="528" height="84" alt="Screenshot 2025-11-23 203905" src="https://github.com/user-attachments/assets/12c1e9f4-b6c9-4f75-8083-60763749e245" />

## Kesimpulan
Desain keamanan ini bertujuan menciptakan lingkungan yang aman namun fleksibel, dengan membatasi akses yang tidak sah dan mendukung kolaborasi antar departemen. Kebijakan **ACL** dan **Firewall** yang terkonfigurasi dengan baik menjadi kunci utama dalam mendukung kebijakan ini.

# 3. Bagaimana kalian membuktikan bahwa sistem kalian “benar-benar bekerja”?

## A. Indikator Keamanan
Kami menetapkan tiga indikator utama untuk mengukur efektivitas firewall:

1.  **Status Port:**
    * Filtered: Menandakan paket dibuang oleh ACL/Firewall (Target Aman).
    * Open: Hanya boleh muncul pada layanan publik yang diizinkan (Web Riset).
    * Closed: Menandakan layanan tidak berjalan, atau ditolak oleh host (bukan firewall).

2.  **Log Router:**
    * Setiap paket ilegal yang diblokir wajib memicu log pada Core Router.
    * Bukti Config: logging buffered 16384 debugging dan penambahan flag log pada setiap baris deny di ACL.

3.  **Application Response:**
    * SHTTP 200 OK untuk akses legal (Mahasiswa ke Web Riset).
    * Connection Timeout/Refused untuk akses ilegal (SSH Brute Force).

## B. Metodologi Pengujian
Kami merancang skenario pengujian untuk memastikan Akurasi:

- Mencegah False Positive (Memblokir yang seharusnya Boleh): Kami menguji akses Mahasiswa ke Server Riset. Jika gagal, berarti keamanan terlalu ketat (False Positive).

- Mencegah False Negative (Meloloskan yang seharusnya Dilarang): Kami menguji akses Guest ke Admin. Jika berhasil masuk, berarti keamanan gagal (False Negative).

Hasil Pengujian:

## C. Verifikasi Performa
Keamanan yang ketat tidak boleh mematikan jaringan. Kami menguji ketahanan Core Router saat diserang menggunakan Stress Test:

1.  **Uji Availability saat Serangan DoS:**
    * Metode: Menjalankan icmp_flood.sh dan synflood.sh dari PC Mahasiswa ke Gateway Core.
    * Observasi: CPU Router sempat naik, namun Router tidak crash. Akses internet dari PC lain (misal Admin) tetap berjalan meskipun sedikit melambat.
    * Kesimpulan: ACL yang dipasang pada interface IN (Inbound) sangat efisien karena paket sampah langsung dibuang sebelum membebani prosesor routing utama.

2. **Uji Latency:**
    * Normal: Ping ke Gateway = <1ms.
    * Saat Load Tinggi: Ping naik menjadi 2-5ms, masih dalam batas toleransi layak (acceptable) untuk lingkungan kampus.

# 4. Bagaimana kalian merancang sistem yang tetap adaptif?
Untuk menjawab tantangan skalabilitas, kami meninggalkan pendekatan konfigurasi statis manual. Kami mengadopsi arsitektur Hierarkis Modular yang didukung oleh protokol routing dinamis dan manajemen kebijakan berbasis zona. Berikut adalah 3 pilar utama desain adaptif kami:

## A. Skalabilitas Jaringan melalui Routing Dinamis (OSPF)
Kami tidak menggunakan Static Routing (ip route) untuk komunikasi antar-router internal. Sebaliknya, kami mengimplementasikan protokol OSPF (Open Shortest Path First) dengan Process ID 1 pada seluruh router (Core, Edge, Admin, Riset, dll).
- **Mengapa Adaptif?** OSPF memungkinkan jaringan untuk **menyembuhkan diri sendiri** dan **belajar otomatis**. Jika ada router baru ditambahkan, Core Router akan otomatis menerima informasi subnet baru tersebut melalui paket Link State Advertisement (LSA) tanpa intervensi manual administrator.
- **Bukti Konfigurasi:** Pada AdminRouter, konfigurasi OSPF diterapkan untuk mengenalkan subnet lokal `10.20.40.0/24` ke backbone . Hal serupa diterapkan di semua router departemen.
- **Dampak Nyata:** Jika ITS membangun gedung baru (misal: Fakultas Kedokteran), tim IT hanya perlu mengonfigurasi router baru tersebut untuk bergabung ke OSPF Area 0. Dalam hitungan detik, seluruh jaringan kampus (termasuk Internet Gateway) akan mengenali jalur ke gedung baru tersebut.

## B. Manajemen Keamanan Modular (Zone-Based ACL Policy)
Alih-alih membuat satu Access Control List (ACL) raksasa yang mencampuradukkan semua aturan, kami menerapkan Modular ACL yang dipasang berdasarkan antarmuka sumber (Ingress Interface).

**Desain Modular: Kebijakan keamanan dipisah berdasarkan fungsi departemen, bukan sekadar IP address.**
  * ACL_FROM_MHS : Khusus mengatur batasan Mahasiswa (Blokir ke Admin & DB).
  * ACL_FROM_EDGE : Khusus menangani ancaman eksternal/Guest.
  * ACL_FROM_AKADEMIK : Khusus mengatur hak akses staf akademik.

**Keuntungan Adaptabilitas:**
 * Isolasi Perubahan: Jika kebijakan untuk Mahasiswa berubah (misal: Mahasiswa S2 diizinkan akses Database), kami hanya perlu menyunting ACL_FROM_MHS. ACL lain (Guest/Riset) tidak akan tersentuh, meminimalkan risiko human error yang bisa mematikan koneksi departemen lain.
 * Kemudahan Audit: Saat terjadi insiden, admin dapat langsung memeriksa ACL spesifik berdasarkan lokasi serangan tanpa perlu menelusuri ribuan baris kode.

## C. Standardisasi Infrastruktur
Kami mengantisipasi kebutuhan penambahan server dengan cepat. Oleh karena itu, kami membuat skrip instalasi standar (setup_server.zip) yang berfungsi sebagai blueprint infrastruktur.

- Mekanisme: Skrip `install.sh` dan `server_admin.sh` menstandarisasi paket keamanan yang wajib ada di setiap server baru (seperti Fail2Ban, konfigurasi SSH yang diperketat, dan Logging).
- Skenario Pengembangan: Jika dibutuhkan **Server Cloud** baru, administrator cukup menjalankan skrip tersebut. Server baru akan langsung memiliki standar keamanan yang setara dengan server lama dalam waktu kurang dari 5 menit, menjamin konsistensi keamanan di seluruh infrastruktur.

## D. Simulasi Pengembangan Jaringan
Berikut adalah simulasi langkah kerja jika kami menambahkan **Lab Bahasa** baru ke dalam topologi:

1.  **Hardware: Sambungkan Router Lab Bahasa ke interface kosong di Core Router (misal f3/0).**
2.  **P Addressing: Berikan IP Transit 10.20.99.20/30.**
3.  **Routing:**
     * router ospf 1
     * network 10.20.60.0 0.0.0.255 area 0
4.  **Hasil:**
     * Tidak perlu mengedit Core Router.
     * Tidak perlu mengedit Edge Router.
     * Lab Bahasa langsung terkoneksi ke Internet dan Server Riset.
     * Keamanan terjaga karena Lab Bahasa belum dimasukkan ke Permit List di subnet Admin.
     
## E. Kesimpulan
Desain ini memenuhi prinsip "High Availability" dan "Scalability". Penggunaan OSPF menghilangkan hambatan administrasi routing, sementara Modular ACL memastikan keamanan tetap ketat namun fleksibel terhadap perubahan kebijakan kampus yang dinamis.



