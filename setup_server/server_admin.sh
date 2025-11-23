# Install SSH dan tools
apt update && apt install -y openssh-server netcat-openbsd tcpdump nmap fail2ban rsyslog

# Konfigurasi SSH
cat > /etc/ssh/sshd_config << 'EOF'
Port 22
PermitRootLogin yes
PasswordAuthentication yes
MaxAuthTries 3
LoginGraceTime 60
LogLevel VERBOSE
EOF

# Set password root untuk testing
echo "root:admin123" | chpasswd

# Start SSH
service ssh start

# Setup fail2ban untuk deteksi brute force
cat > /etc/fail2ban/jail.local << 'EOF'
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 600
findtime = 600
EOF

service fail2ban start

# Verifikasi
netstat -tlnp | grep :22
echo "✅ SSH Server siap di port 22"