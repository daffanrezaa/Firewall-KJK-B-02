# PANDUAN LENGKAP PENGERJAAN TUGAS IDS (MANUAL)

Dokumen ini adalah panduan langkah-demi-langkah (step-by-step) untuk menyelesaikan Tugas IDS secara **MANUAL**.
---

## 1. Persiapan Topologi (Wajib Dilakukan di GNS3)

Sebelum masuk ke konfigurasi, pastikan topologi jaringan Anda sudah benar.

**Langkah 1: Tambahkan Node IDS**
*   Drag & drop node baru (Docker Container) ke workspace GNS3.
*   Gunakan image: `nevarre/gns3-debi:latest` (atau image Debian/Ubuntu lain yang tersedia).
*   Ubah nama node menjadi: **Suricata-IDS**.

**Langkah 2: Tentukan Posisi IDS (PENTING!)**
Tugas meminta monitoring traffic:
1.  **Mahasiswa → Riset**
2.  **Mahasiswa → Akademik**
3.  **Riset → Mahasiswa**

Untuk menangkap ketiga jalur ini sekaligus:
*   **REKOMENDASI**: Letakkan IDS di antara **Router Mahasiswa** dan **Core Router**.
*   **Caranya**:
    1.  Putuskan kabel antara Router Mahasiswa dan Core Router.
    2.  Pasang sebuah **Ethernet Hub** di antara keduanya.
    3.  Sambungkan `Router Mahasiswa` -> `Hub`.
    4.  Sambungkan `Core Router` -> `Hub`.
    5.  Sambungkan `Suricata-IDS` -> `Hub`.
    *   *Penjelasan*: Hub akan menyebarkan (broadcast) paket ke semua port, sehingga IDS bisa "mengintip" semua paket yang lewat di jalur utama ini.

---

## 2. Instalasi Suricata (Pada Node IDS)

Buka console/terminal pada node **Suricata-IDS**.

**Langkah 1: Update & Install**
Ketik perintah berikut:
```bash
apt-get update
apt-get install -y suricata net-tools nano curl
```

**Langkah 2: Matikan Offloading (Penting di Virtual)**
Agar paket captured tidak corrupt/incomplete:
```bash
ethtool -K eth0 rx off tx off sg off gso off gro off
```
*(Abaikan jika muncul error operation not supported, lanjut saja)*

---

## 3. Konfigurasi Suricata (Pada Node IDS)

**Langkah 1: Buat File Rules Custom**
Kita akan membuat file aturan deteksi sendiri.
```bash
nano /etc/suricata/rules/custom.rules
```

**Langkah 2: Isi Rules**
Salin (Copy-Paste) teks di bawah ini ke dalam file `custom.rules` tersebut. Pastikan sama persis.

```suricata
# ========================================================
# CUSTOM RULES - TUGAS KJK KELOMPOK
# ========================================================

# 1. DETEKSI SYN SCAN DARI MAHASISWA
# Mencegat scanning ke Riset & Akademik
# Logika: >20 paket SYN dalam 10 detik = Scanning.
alert tcp 10.20.10.0/24 any -> 10.20.30.0/24 any (msg:"⚠️  WARNING: SYN Scan from Mahasiswa to Riset Network"; flags:S; threshold: type both, track by_src, count 20, seconds 10; classtype:attempted-recon; sid:2000001; rev:2;)
alert tcp 10.20.10.0/24 any -> 10.20.20.0/24 any (msg:"⚠️  WARNING: SYN Scan from Mahasiswa to Akademik Network"; flags:S; threshold: type both, track by_src, count 20, seconds 10; classtype:attempted-recon; sid:2000004; rev:1;)

# 2. DETEKSI SSH BRUTE FORCE
# Logika: >3 percobaan koneksi baru ke port 22 dalam 30 detik.
alert tcp 10.20.10.0/24 any -> 10.20.30.10 22 (msg:"🚨 CRITICAL: SSH Brute Force Attempt from Mahasiswa to Riset Server"; flags:S; threshold: type both, track by_src, count 3, seconds 30; classtype:attempted-user; sid:2000002; rev:1;)

# 3. DETEKSI DATA EXFILTRATION (HTTP)
# Logika: Server Riset mengirim respon HTTP 200 OK ke Mahasiswa (File berhasil didapat).
alert http 10.20.30.10 any -> 10.20.10.0/24 any (msg:"🚨 CRITICAL: Suspicious File Transfer / Data Exfiltration from Riset Server"; flow:established,from_server; http.response_code; content:"200"; classtype:policy-violation; sid:2000003; rev:1;)
```
*Simpan file dengan `Ctrl+O`, `Enter`, lalu `Ctrl+X`.*

**Langkah 3: Edit Konfigurasi Utama**
Buka file konfigurasi utama Suricata:
```bash
nano /etc/suricata/suricata.yaml
```

Cari bagian `rule-files:` (biasanya di bagian bawah). Ubah agar **HANYA** memuat file custom kita (supaya ringan dan fokus):

```yaml
rule-files:
  - /etc/suricata/rules/custom.rules
#  - suricata.rules  <-- Beri tanda pagar (#) pada rules bawaan lainnya
```

Pastikan juga setting jaringan benar (opsional tapi disarankan):
*   Cari `HOME_NET`: Ubah jadi `"[10.20.0.0/16]"`
*   Cari `EXTERNAL_NET`: Ubah jadi `"!$HOME_NET"`

*Simpan dan keluar (`Ctrl+X`).*

---

## 4. Menjalankan IDS (Pada Node IDS)

Sekarang kita aktifkan "CCTV" jaringan kita.

**Langkah 1: Jalankan Suricata**
```bash
suricata -c /etc/suricata/suricata.yaml -i eth0 -D
```
*   `-c`: Lokasi config
*   `-i`: Interface yang didengar (eth0)
*   `-D`: Daemon mode (jalan di background)

**Langkah 2: Pantau Log (Real-time)**
Kita buka layar monitor untuk melihat alert yang masuk.
```bash
tail -f /var/log/suricata/fast.log
```
*Biarkan terminal ini terbuka! Jangan ditutup. Pindah ke node lain untuk melakukan serangan.*

---

## 5. Simulasi Serangan (Pada Node Mahasiswa)

Buka console/terminal pada **Node PC-Mahasiswa**. Anda berperan sebagai Hacker.

**Skenario A: Scanning Jaringan (Reconnaissance)**
Kita akan scan Server Riset & Akademik.

1.  Jalankan perintah scan ke Riset:
    ```bash
    nmap -sS -p 22,80,443 10.20.30.10
    ```
2.  Jalankan perintah scan ke Akademik:
    ```bash
    nmap -sS -p 3306,80 10.20.20.10
    ```
    *Lihat ke terminal IDS: Harus muncul alert "WARNING: SYN Scan..."*

**Skenario B: SSH Brute Force**
Kita coba paksa masuk SSH ke Server Riset.

1.  Buat file password dummy (jika belum ada):
    ```bash
    echo -e "123\n456\npassword\nadmin" > passlist.txt
    ```
2.  Jalankan Hydra:
    ```bash
    hydra -l admin -P passlist.txt ssh://10.20.30.10 -t 4 -V
    ```
    *Lihat ke terminal IDS: Harus muncul alert "CRITICAL: SSH Brute Force..."*

**Skenario C: Pencurian Data (Exfiltration)**
Kita coba download file rahasia dari Server Riset.

1.  Download file (asumsi ada webserver di 10.20.30.10):
    ```bash
    wget http://10.20.30.10/confidential.data
    ```
    *(Jika gagal/404 tidak apa-apa, coba download halaman utama saja):*
    ```bash
    wget http://10.20.30.10/
    ```
    *Lihat ke terminal IDS: Harus muncul alert "CRITICAL: Suspicious File Transfer..."*

---

## 6. Selesai

Jika ketiga alert muncul di terminal IDS, berarti tugas Anda **BERHASIL** 100%.
Jangan lupa screenshot bukti alert tersebut untuk laporan.
