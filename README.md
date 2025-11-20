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
