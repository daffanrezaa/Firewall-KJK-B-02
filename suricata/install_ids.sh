#!/bin/bash

echo "============================================"
echo "🔧 INSTALLING SURICATA IDS"
echo "============================================"

# 1. Install dependencies & Suricata
apt update
apt install -y suricata jq curl net-tools nano

# 2. Backup config asli
cp /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.bak

# 3. Copy custom rules kita ke direktori rules
# (Diasumsikan script ini dijalankan dari folder yang sama dengan custom.rules)
if [ -f "custom.rules" ]; then
    cp custom.rules /etc/suricata/rules/custom.rules
    echo "✅ Custom rules copied."
else
    echo "❌ ERROR: File custom.rules tidak ditemukan!"
    exit 1
fi

# 4. Konfigurasi suricata.yaml secara otomatis
echo "⚙️ Configuring Suricata..."

# Ubah interface default ke eth0
sed -i 's/interface: eth0/interface: eth0/g' /etc/suricata/suricata.yaml

# Tambahkan custom.rules ke daftar rule-files
# Hapus daftar rules default dulu agar tidak berat, lalu masukkan custom.rules
sed -i '/rule-files:/q' /etc/suricata/suricata.yaml
echo "  - /etc/suricata/rules/custom.rules" >> /etc/suricata/suricata.yaml

# Nonaktifkan checksum offloading (Penting untuk capture di virtual env)
ethtool -K eth0 rx off tx off sg off gso off gro off 2>/dev/null || echo "⚠️ Ethtool warning (ignored)"

echo "============================================"
echo "✅ INSTALLATION COMPLETE"
echo "Run './run_ids.sh' to start detection."
echo "============================================"
