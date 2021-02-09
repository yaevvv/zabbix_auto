DB_PASS - password of DB Zabbix (user zabbix) First login to the web-admin: User: Admin Pass: zabbix

docker pull shut2000 / gin_zabbix: latest docker run -d -e DB_PASS = "password_db"

It was done according to the principle "Head-on" - everything in one container Do it right

mysql and zabbix containers (images)
add directory forwarding (Zabbix scripts, logs, configuration files)
make the main image (everything that does not change or rarely changes does not pack again) and based on it do the installation
make some variables (except DB_PASS) to start Zabbix
