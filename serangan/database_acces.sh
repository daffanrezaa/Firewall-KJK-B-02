# === JALANKAN DI PC-MAHASISWA-1 ===

echo "============================================"
echo "🔴 SERANGAN 4: Database Access Attempt"
echo "============================================"

# Attack 1: Direct MySQL connection dengan netcat
echo -e "\n[ATTACK 1] MySQL Connection Attempt (10.20.20.10:3306)"
echo "Command: nc -zv -w 3 10.20.20.10 3306"
timeout 5 nc -zv 10.20.20.10 3306 2>&1
if [ $? -ne 0 ]; then
    echo "✅ ATTACK BLOCKED: MySQL port 3306 filtered/refused"
else
    echo "⚠️  VULNERABILITY: MySQL port accessible!"
fi

# Attack 2: Telnet ke MySQL
echo -e "\n[ATTACK 2] Telnet ke MySQL port 3306"
echo "Command: timeout 3 telnet 10.20.20.10 3306"
timeout 3 telnet 10.20.20.10 3306 2>&1 | head -10
if [ ${PIPESTATUS[0]} -eq 124 ]; then
    echo "✅ ATTACK BLOCKED: Connection timeout"
fi

# Attack 3: MySQL client attempt (jika terinstall)
echo -e "\n[ATTACK 3] MySQL Client Connection Attempt"
echo "Command: timeout 5 mysql -h 10.20.20.10 -u akademik -ppassword123"
timeout 5 mysql -h 10.20.20.10 -u akademik -ppassword123 -e "SHOW DATABASES;" 2>&1 | head -10
if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "✅ ATTACK BLOCKED: Cannot connect to database"
else
    echo "⚠️  VULNERABILITY: Database accessible from Mahasiswa zone!"
fi

# Attack 4: Nmap service detection
echo -e "\n[ATTACK 4] Service Detection Scan"
echo "Command: nmap -Pn -sV -p 3306 10.20.20.10"
nmap -Pn -sV -p 3306 10.20.20.10

echo -e "\n============================================"
echo "📊 HASIL: DB:3306 HARUS filtered (BLOCKED by ACL)"
echo "Data akademik terlindungi dari akses unauthorized"
echo "============================================"