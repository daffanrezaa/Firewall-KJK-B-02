#!/bin/bash

echo "🚀 STARTING SURICATA IDS..."

# Pastikan log directory ada
mkdir -p /var/log/suricata

# Jalankan Suricata
# -c: config file
# -i: interface
# -D: daemon mode (background)
suricata -c /etc/suricata/suricata.yaml -i eth0 -D

echo "✅ Suricata is running in background."
echo "logs are at: /var/log/suricata/fast.log"
echo ""
echo "To view logs in real-time, run: ./monitor_logs.sh"
