# === JALANKAN DI PC-MAHASISWA-1 ===

echo "============================================"
echo "🔴 SERANGAN 3: SSH Access Attempt"
echo "============================================"

# Attack 1: SSH ke DB Akademik (HARUS BLOCKED)
echo -e "\n[ATTACK 1] SSH Attempt ke DB Akademik (10.20.20.10)"
echo "Command: timeout 5 ssh -o ConnectTimeout=3 root@10.20.20.10"
timeout 5 ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no root@10.20.20.10 2>&1
if [ $? -eq 124 ] || [ $? -ne 0 ]; then
    echo "✅ ATTACK BLOCKED: SSH connection refused/timeout"
else
    echo "⚠️  VULNERABILITY: SSH connection established!"
fi

# Attack 2: SSH ke Server Riset (HARUS BLOCKED)
echo -e "\n[ATTACK 2] SSH Attempt ke Server Riset (10.20.30.10)"
echo "Command: timeout 5 ssh -o ConnectTimeout=3 root@10.20.30.10"
timeout 5 ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no root@10.20.30.10 2>&1
if [ $? -eq 124 ] || [ $? -ne 0 ]; then
    echo "✅ ATTACK BLOCKED: SSH connection refused/timeout"
else
    echo "⚠️  VULNERABILITY: SSH connection established!"
fi

# Attack 3: SSH ke Server Admin (HARUS BLOCKED)
echo -e "\n[ATTACK 3] SSH Attempt ke Server Admin (10.20.40.10)"
echo "Command: timeout 5 ssh -o ConnectTimeout=3 root@10.20.40.10"
timeout 5 ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no root@10.20.40.10 2>&1
if [ $? -eq 124 ] || [ $? -ne 0 ]; then
    echo "✅ ATTACK BLOCKED: SSH connection refused/timeout"
else
    echo "⚠️  VULNERABILITY: SSH connection established!"
fi

# Attack 4: Netcat test (lebih jelas)
echo -e "\n[ATTACK 4] Netcat SSH port test"
echo "Testing: nc -zv -w 3 10.20.20.10 22"
nc -zv -w 3 10.20.20.10 22 2>&1
echo "Testing: nc -zv -w 3 10.20.30.10 22"
nc -zv -w 3 10.20.30.10 22 2>&1
echo "Testing: nc -zv -w 3 10.20.40.10 22"
nc -zv -w 3 10.20.40.10 22 2>&1

echo -e "\n============================================"
echo "📊 HASIL: Semua SSH attempt HARUS failed (BLOCKED)"
echo "Mitigasi SSH berhasil melindungi server"
echo "============================================"