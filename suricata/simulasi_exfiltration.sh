#!/bin/bash
# ==============================================================================
# SCRIPT SIMULASI: DATA EXFILTRATION (HTTP)
# ==============================================================================
# INSTRUKSI PENGGUNAAN:
# 1. Salin script ini ke Node Mahasiswa.
# 2. Beri izin eksekusi: chmod +x simulasi_exfiltration.sh
# 3. Jalankan: ./simulasi_exfiltration.sh
#
# PRASYARAT:
# Server Riset (10.20.30.10) harus memiliki Web Server (Apache/Nginx) yang aktif
# dan bisa melayani file (misal file dummy 'confidential.txt' atau default index.html)
# ==============================================================================

TARGET="10.20.30.10" # IP Server Riset
FILE="confidential_data.enc" # Nama file dummy yang akan "dicuri"

echo "[*] Memulai Simulasi Serangan: Data Exfiltration (Mahasiswa -> Riset)"
echo "[*] Target: http://$TARGET/$FILE"
echo "------------------------------------------------------------------"

echo "[+] Mencoba mengunduh file sensitif via HTTP..."

# Menggunakan wget untuk mensimulasikan exfiltration
# Jika file tidak ada di server, wget akan 404, tapi koneksi tetap terjadi.
# Untuk trigger rule "200 OK", pastikan file ada atau request file yang pasti ada (misal index.html)
wget -q --show-progress "http://$TARGET/$FILE"

if [ $? -eq 0 ]; then
    echo "[+] SUCCESS: File berhasil diunduh (Exfiltration berhasil)."
else
    echo "[-] FAILED: Gagal mengunduh $FILE (Mungkin file tidak ada di server?)."
    echo "[*] Mencoba alternatif: Mengunduh index.html default..."
    wget -q --show-progress "http://$TARGET/"
fi

echo "------------------------------------------------------------------"
echo "[*] Simulasi Selesai. Cek alert pada IDS (fast.log)"
