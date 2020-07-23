FROM ubuntu:16.04

##### Установка основных пакетов
RUN apt-get update && apt-get install -y wget nginx php php-fpm php-mysql php-pear php-cgi php-common php-ldap php-mbstring php-snmp php-gd php-xml php-gettext php-bcmath && \
    wget  https://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1+xenial_all.deb && \
    dpkg -i zabbix-release_4.4-1+xenial_all.deb && \
    apt update && apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-agent

# Првильные параметры php.ini
RUN sed -i 's/^post_max_size =.*/post_max_size = 16M/' /etc/php/7.0/fpm/php.ini && \
    sed -i 's/^max_input_time =.*/max_input_time = 300/' /etc/php/7.0/fpm/php.ini && \
    sed -i 's/^max_input_vars =.*/max_input_vars = 10000/' /etc/php/7.0/fpm/php.ini && \
    sed -i 's/^max_execution_time =.*/max_execution_time = 300/' /etc/php/7.0/fpm/php.ini && \
    echo 'date.timezone = "Europe/Kiev"' >> /etc/php/7.0/fpm/php.ini

# Скрипт старта сервисов и создания БД Zabbix.Можно, как вариант запустить suoervisor
COPY start.sh /opt/
# Преднастроенный файл конфигурации для nginx
COPY default /etc/nginx/sites-available/

COPY zabbix.conf.php /etc/zabbix/web

# Установка доступов 
RUN mkdir -p /var/run/zabbix && mkdir -p /var/run/php && \
    chown -R zabbix:zabbix /var/log/zabbix && \
    chown -R zabbix:zabbix /var/run/zabbix && \
    chmod -R 775 /var/log/zabbix/ && \
    chmod -R 775 /var/run/zabbix/
EXPOSE 80/TCP 443/TCP 10050/TCP
VOLUME /etc/zabbix
CMD ["/bin/sh", "-c", "/opt/start.sh"]
