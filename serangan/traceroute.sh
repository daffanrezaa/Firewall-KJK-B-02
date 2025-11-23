# === JALANKAN DI PC-MAHASISWA-1 ===

echo "============================================"
echo "🔴 SERANGAN 7: Traceroute Network Mapping"
echo "============================================"

# Attack 1: Traceroute ke Admin (HARUS BLOCKED)
echo -e "\n[ATTACK 1] Traceroute ke Admin (10.20.40.10)"
echo "Command: traceroute -n -m 10 10.20.40.10"
traceroute -n -m 10 10.20.40.10
echo "Expected: Stopped at CoreRouter, tidak sampai destination"

# Attack 2: Traceroute ke Riset (HARUS COMPLETE)
echo -e "\n[ATTACK 2] Traceroute ke Riset (10.20.30.10)"
echo "Command: traceroute -n -m 10 10.20.30.10"
traceroute -n -m 10 10.20.30.10
echo "Expected: Complete path ke destination (ALLOWED)"

# Attack 3: Traceroute ke DB
echo -e "\n[ATTACK 3] Traceroute ke DB Akademik (10.20.20.10)"
echo "Command: traceroute -n -m 10 10.20.20.10"
traceroute -n -m 10 10.20.20.10
echo "Expected: Path complete tapi port 3306 blocked"

echo -e "\n============================================"
echo "📊 HASIL: Network topology bisa di-map, tapi access tetap restricted"
echo "============================================"