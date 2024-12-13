#!/usr/bin/env bash
UNIQUE_HOSTNAME="rohacek-debian$(uuidgen)"
SHORT_HOSTNAME=$(echo $UNIQUE_HOSTNAME | cut -d'-' -f1,2)

# Záloha původního zabbix_agent2.conf
sudo cp -v /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf-orig

# konfigurace zabbix_agent2.conf
sudo sed -i "s/Hostname=Zabbix server/Hostname=$SHORT_HOSTNAME/g" /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/Server=127.0.0.1/Server=enceladus.pfsense.cz/g' /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/ServerActive=127.0.0.1/ServerActive=enceladus.pfsense.cz/g' /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/# Timeout=3/Timeout=30/g' /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/# HostMetadata=/HostMetadata=SPOS/g' /etc/zabbix/zabbix_agent2.conf
sudo diff -u /etc/zabbix/zabbix_agent2.conf-orig /etc/zabbix/zabbix_agent2.conf
#restart zabbixu
sudo systemctl restart zabbix-agent2

sudo systemctl status zabbix-agent2 --no-pager