
wget https://repo.zabbix.com/zabbix/7.0/debian-arm64/pool/main/z/zabbix-release/zabbix-release_latest_7.0+debian12_all.deb
dpkg -i zabbix-release_latest_7.0+debian12_all.deb
apt update -y
sudo apt upgrade

apt install zabbix-server-pgsql zabbix-frontend-php php8.2-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y

# INSTAL DATABÁZE
sudo apt install postgresql postgresql-contrib -y
sudo systemctl enable postgresql

# SETUP DATABÁZE
sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix

zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix

# tady se to rozbíjí
sudo sed '$ a DBPassword=password' /etc/zabbix/zabbix_server.conf

systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2

# Konfigurace PHP pro Zabbix frontend
sudo sed -i 's/^max_execution_time = .*/max_execution_time = 300/' /etc/php/*/apache2/php.ini
sudo sed -i 's/^memory_limit = .*/memory_limit = 128M/' /etc/php/*/apache2/php.ini
sudo sed -i 's/^post_max_size = .*/post_max_size = 16M/' /etc/php/*/apache2/php.ini
sudo sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 2M/' /etc/php/*/apache2/php.ini
sudo sed -i 's/^;date.timezone =.*/date.timezone = Europe\/Prague/' /etc/php/*/apache2/php.ini

# Restart Apache pro načtení změn
sudo systemctl restart apache2