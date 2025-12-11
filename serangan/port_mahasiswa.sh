#!/bin/bash
# Script simulasi port scanning (SYN Scan)
# Dijalankan dari Node Mahasiswa

TARGET="10.20.30.10" # Server Riset
SUBNET_TARGET="10.20.30.0/24"

echo "========================================="
echo "   SIMULASI PORT SCANNING (NMAP)"
echo "   Mahasiswa -> Riset Network"
echo "========================================="

echo "[*] Melakukan SYN Scan ke Server Riset ($TARGET)..."
# -sS: SYN Scan (Stealth)
# -p: Port spesifik yang disebut di kasus (22, 80, 443)
nmap -sS -p 22,80,443 $TARGET

echo ""
echo "[*] Melakukan Fast Scan ke seluruh Subnet Riset ($SUBNET_TARGET)..."
nmap -F $SUBNET_TARGET
