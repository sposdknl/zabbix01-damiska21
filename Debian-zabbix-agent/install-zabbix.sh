#!/usr/bin/env bash

sudo apt-get install -y net-tools

wget wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_latest+debian12_all.deb

sudo dpkg -i zabbix-release_latest+debian12_all.deb

sudo apt update -y

sudo apt install zabbix-agent2 zabbix-agent2-plugin-*

# Povolení služby Zabbix Agent2
sudo systemctl enable zabbix-agent2

# Spuštění a restart služby Zabbix Agent2
sudo systemctl restart zabbix-agent2

# Kontrola stavu služby Zabbix Agent2
sudo systemctl status zabbix-agent2 --no-pager