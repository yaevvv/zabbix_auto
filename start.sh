#!/bin/bash

service mysql restart
if [[  -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='db'" 2>&1`" ]];
then
    echo "use mysql;CREATE DATABASE zabbix DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_bin;GRANT ALL PRIVILEGES ON zabbix.* TO zabbix@localhost IDENTIFIED BY '${DB_PASS}';" | mysql -uroot
    gunzip /usr/share/doc/zabbix-server-mysql/create.sql.gz
    echo "use zabbix;source /usr/share/doc/zabbix-server-mysql/create.sql;" | mysql -uzabbix -p${DB_PASS}
    echo "DBPassword=${DB_PASS}" >> /etc/zabbix/zabbix_server.conf
    echo "\$DB['PASSWORD'] = '"${DB_PASS}"';" >> /etc/zabbix/web/zabbix.conf.php
fi

service php7.0-fpm restart
service nginx restart
/usr/sbin/zabbix_server --foreground -c /etc/zabbix/zabbix_server.conf
