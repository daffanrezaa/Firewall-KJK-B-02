# === JALANKAN DI PC-MAHASISWA-1 ===

echo "============================================"
echo "🔴 SERANGAN 8: Fragmentation Attack"
echo "============================================"

# Attack 1: Fragmented ICMP ke Admin
echo -e "\n[ATTACK 1] Fragmented ICMP ke Admin (10.20.40.10)"
echo "Command: hping3 --icmp --frag -c 20 10.20.40.10"
timeout 10 hping3 --icmp --frag -c 20 10.20.40.10 2>&1 | head -20
echo "Expected: BLOCKED jika mitigasi fragmentation diterapkan"

# Attack 2: Fragmented TCP ke DB:3306
echo -e "\n[ATTACK 2] Fragmented TCP ke DB:3306 (10.20.20.10)"
echo "Command: hping3 -S -p 3306 --frag -c 20 10.20.20.10"
timeout 10 hping3 -S -p 3306 --frag -c 20 10.20.20.10 2>&1 | head -20
echo "Expected: BLOCKED oleh ACL anti-fragmentation"

# Attack 3: Tiny fragments
echo -e "\n[ATTACK 3] Tiny Fragments Attack"
echo "Command: hping3 -S -p 3306 --frag -d 8 -c 20 10.20.20.10"
timeout 10 hping3 -S -p 3306 --frag -d 8 -c 20 10.20.20.10 2>&1 | head -20
echo "Expected: BLOCKED (fragmentation protection)"

echo -e "\n============================================"
echo "📊 HASIL: Fragmented packets HARUS blocked setelah mitigasi"
echo "ACL anti-fragmentation mencegah firewall bypass"
echo "============================================"