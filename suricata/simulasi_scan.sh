#!/bin/bash
# ==============================================================================
# SCRIPT SIMULASI: PORT SCANNING (SYN SCAN)
# ==============================================================================
# INSTRUKSI PENGGUNAAN:
# 1. Salin script ini ke Node Mahasiswa (misal: PC-Mhs-1 atau Docker Container Mahasiswa).
# 2. Beri izin eksekusi: chmod +x simulasi_scan.sh
# 3. Jalankan: ./simulasi_scan.sh
# ==============================================================================

TARGET="10.20.30.10" # IP Server Riset
SUBNET_TARGET="10.20.30.0/24"
TARGET_AKADEMIK="10.20.20.10" # IP Server Akademik

echo "[*] Memulai Simulasi Serangan: Port Scanning (Mahasiswa -> Riset & Akademik)"
echo "[*] Target Riset: $TARGET"
echo "[*] Target Akademik: $TARGET_AKADEMIK"
echo "------------------------------------------------------------------"

# 1. SYN Scan Riset (Trigger Rule: SYN Scan from Mahasiswa -> Riset)
echo "[+] Melakukan Nmap SYN Scan (-sS) ke Server Riset..."
nmap -sS -p 22,80,443 $TARGET

# 2. SYN Scan Akademik (Trigger Rule: SYN Scan from Mahasiswa -> Akademik)
echo ""
echo "[+] Melakukan Nmap SYN Scan (-sS) ke Server Akademik..."
nmap -sS -p 3306,80 $TARGET_AKADEMIK

echo ""
echo "[+] Melakukan Fast Scan (-F) ke seluruh subnet..."
nmap -F $SUBNET_TARGET

echo "------------------------------------------------------------------"
echo "[*] Simulasi Selesai. Cek alert pada IDS (fast.log)"
