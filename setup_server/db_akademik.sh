
# Install MySQL/MariaDB
apt update && apt install -y mariadb-server netcat-openbsd tcpdump nmap

# Start MySQL
service mariadb start

# Konfigurasi agar MySQL listen di semua interface
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Restart MySQL
service mariadb restart

# Verifikasi MySQL berjalan di port 3306
netstat -tlnp | grep :3306

# Buat database dummy untuk testing
mysql -u root << 'EOF'
CREATE DATABASE akademik_db;
CREATE USER 'akademik'@'%' IDENTIFIED BY 'password123';
GRANT ALL PRIVILEGES ON akademik_db.* TO 'akademik'@'%';
FLUSH PRIVILEGES;
USE akademik_db;
CREATE TABLE mahasiswa (id INT, nama VARCHAR(100), nim VARCHAR(20));
INSERT INTO mahasiswa VALUES (1, 'Test User', '5027241001');
EOF

echo "✅ Database Akademik siap di port 3306"