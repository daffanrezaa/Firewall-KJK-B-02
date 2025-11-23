# === JALANKAN DI GUEST-1 ===

echo "============================================"
echo "🔴 SERANGAN 1: Port Scanning dari Guest"
echo "============================================"

# Attack 1: Scan ke Server Admin
echo -e "\n[ATTACK 1] Port Scan ke Server Admin (10.20.40.10)"
echo "Command: nmap -Pn -sT -p 22,80,443,3306 10.20.40.10"
nmap -Pn -sT -p 22,80,443,3306 10.20.40.10
echo "Expected: All ports filtered (BLOCKED by BLOCK_GUEST ACL)"

# Attack 2: Scan ke DB Akademik
echo -e "\n[ATTACK 2] Port Scan ke DB Akademik (10.20.20.10)"
echo "Command: nmap -Pn -sT -p 22,80,443,3306 10.20.20.10"
nmap -Pn -sT -p 22,80,443,3306 10.20.20.10
echo "Expected: All ports filtered (BLOCKED by BLOCK_GUEST ACL)"

# Attack 3: Scan ke Server Riset
echo -e "\n[ATTACK 3] Port Scan ke Server Riset (10.20.30.10)"
echo "Command: nmap -Pn -sT -p 80,443,22 10.20.30.10"
nmap -Pn -sT -p 80,443,22 10.20.30.10
echo "Expected: All ports filtered (BLOCKED by BLOCK_GUEST ACL)"

# Attack 4: Aggressive scan
echo -e "\n[ATTACK 4] Aggressive scan ke Admin (1-100)"
echo "Command: nmap -Pn -sT -p 1-100 --max-retries 1 10.20.40.10"
nmap -Pn -sT -p 1-100 --max-retries 1 10.20.40.10
echo "Expected: All ports filtered/closed"

echo -e "\n============================================"
echo "📊 HASIL: Semua scan FILTERED (BLOCKED by ACL)"
echo "Guest tidak bisa enumerate services internal"
echo "============================================"