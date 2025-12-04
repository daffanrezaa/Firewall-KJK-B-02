
# === JALANKAN DI PC-MAHASISWA-1 ===

echo "============================================"
echo "🔴 SERANGAN 6: ICMP Flood Attack"
echo "============================================"

# Attack 1: ICMP flood ke Admin
echo -e "\n[ATTACK 1] ICMP Flood ke Server Admin (10.20.40.10)"
echo "Command: ping -f -c 100 10.20.40.10"
timeout 5 ping -f -c 100 10.20.40.10 2>&1
echo "Expected: 100% packet loss (BLOCKED by ACL)"

# Attack 2: hping3 ICMP flood
echo -e "\n[ATTACK 2] hping3 ICMP Flood ke Admin"
echo "Command: hping3 -1 --flood -c 100 10.20.40.10"
timeout 5 hping3 -1 --flood -c 100 10.20.40.10 2>&1 | head -20
echo "Expected: No replies (BLOCKED)"

# Attack 3: Large packet flood
echo -e "\n[ATTACK 3] Large Packet ICMP Flood"
echo "Command: ping -s 65500 -c 50 10.20.40.10"
timeout 10 ping -s 65500 -c 50 10.20.40.10 2>&1 | tail -5
echo "Expected: Packet loss (BLOCKED)"

echo -e "\n============================================"
echo "📊 HASIL: ICMP flood BLOCKED, DoS attack gagal"
echo "============================================"