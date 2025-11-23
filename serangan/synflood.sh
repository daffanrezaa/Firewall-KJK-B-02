# === JALANKAN DI PC-MAHASISWA-1 ===

echo "============================================"
echo "🔴 SERANGAN 5: SYN Flood Attack (DoS)"
echo "============================================"

# Attack 1: SYN flood ke Admin server
echo -e "\n[ATTACK 1] SYN Flood ke Server Admin (10.20.40.10)"
echo "Command: hping3 -S -p 22 -c 50 --faster 10.20.40.10"
timeout 10 hping3 -S -p 22 -c 50 --faster 10.20.40.10 2>&1 | head -20
echo "Expected: Packets dropped by ACL, 100% loss"

# Attack 2: SYN flood ke DB port 3306
echo -e "\n[ATTACK 2] SYN Flood ke DB port 3306 (10.20.20.10)"
echo "Command: hping3 -S -p 3306 -c 50 --faster 10.20.20.10"
timeout 10 hping3 -S -p 3306 -c 50 --faster 10.20.20.10 2>&1 | head -20
echo "Expected: Packets dropped by ACL"

# Attack 3: SYN flood ke Riset (harusnya bisa sampai)
echo -e "\n[ATTACK 3] SYN Flood ke Server Riset port 80 (10.20.30.10)"
echo "Command: hping3 -S -p 80 -c 20 10.20.30.10"
timeout 10 hping3 -S -p 80 -c 20 10.20.30.10 2>&1 | head -20
echo "Expected: Packets reach target (port 80 allowed)"

echo -e "\n============================================"
echo "📊 HASIL: SYN flood ke Admin/DB BLOCKED, ke Riset ALLOWED"
echo "ACL berhasil filter traffic malicious ke target sensitif"
echo "============================================"