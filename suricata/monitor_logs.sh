#!/bin/bash
echo "=========================================="
echo "👁️  MONITORING IDS ALERTS (Live)"
echo "=========================================="
echo "Waiting for attacks..."

# Tampilkan isi fast.log secara realtime
tail -f /var/log/suricata/fast.log | awk '{print $0}'
