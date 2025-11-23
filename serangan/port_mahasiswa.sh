# === JALANKAN DI PC-MAHASISWA-1 ===

echo "============================================"
echo "🔴 SERANGAN 2: Port Scanning dari Mahasiswa"
echo "============================================"

# Attack 1: Port scan ke Admin (HARUS FILTERED)
echo -e "\n[ATTACK 1] Port Scan ke Server Admin (10.20.40.10)"
echo "Command: nmap -Pn -sT -p 22,80,443 10.20.40.10"
nmap -Pn -sT -p 22,80,443 10.20.40.10
echo "Expected: All ports FILTERED (BLOCKED by FILTER_MHS)"

# Attack 2: Port scan ke DB port 3306 (HARUS FILTERED)
echo -e "\n[ATTACK 2] Port Scan ke DB port 3306 (10.20.20.10)"
echo "Command: nmap -Pn -sT -p 3306 10.20.20.10"
nmap -Pn -sT -p 3306 10.20.20.10
echo "Expected: Port 3306 FILTERED (BLOCKED by FILTER_MHS)"

# Attack 3: Port scan ke Riset port 80 (HARUS OPEN)
echo -e "\n[ATTACK 3] Port Scan ke Riset port 80 (10.20.30.10)"
echo "Command: nmap -Pn -sT -p 80 10.20.30.10"
nmap -Pn -sT -p 80 10.20.30.10
echo "Expected: Port 80 OPEN (ALLOWED untuk web riset)"

# Attack 4: Scan port 22 ke DB (HARUS FILTERED jika mitigasi sudah diterapkan)
echo -e "\n[ATTACK 4] Port Scan SSH ke DB (10.20.20.10)"
echo "Command: nmap -Pn -sT -p 22 10.20.20.10"
nmap -Pn -sT -p 22 10.20.20.10
echo "Expected: Port 22 FILTERED (jika mitigasi SSH sudah diterapkan)"

# Attack 5: Comprehensive scan (1-100)
echo -e "\n[ATTACK 5] Comprehensive Port Scan ke DB (1-100)"
echo "Command: nmap -Pn -sT -p 1-100 --max-retries 1 10.20.20.10"
nmap -Pn -sT -p 1-100 --max-retries 1 10.20.20.10
echo "Expected: Mayoritas ports FILTERED (proteksi ACL)"

echo -e "\n============================================"
echo "📊 HASIL ANALISIS:"
echo "  ❌ Admin ports: FILTERED (security maintained)"
echo "  ❌ DB:3306: FILTERED (database protected)"
echo "  ✅ Web:80: OPEN (legitimate access allowed)"
echo "============================================"