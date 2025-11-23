
# Update dan install nginx
apt update && apt install -y nginx netcat-openbsd tcpdump nmap hping3

# Buat halaman web sederhana
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Server Riset DTI</title></head>
<body>
<h1>🔬 Portal Riset DTI ITS</h1>
<p>Server ini hanya boleh diakses oleh zona yang diizinkan.</p>
<p>IP: 10.20.30.10 | Port: 80</p>
</body>
</html>
EOF

# Start nginx
service nginx start

# Verifikasi nginx berjalan
netstat -tlnp | grep :80

# Output yang diharapkan:
# tcp  0  0  0.0.0.0:80  0.0.0.0:*  LISTEN  xxx/nginx