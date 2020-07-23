DB_PASS - пароль DB Zabbix(user zabbix)
Первый логин в web-админку: User:Admin Pass:zabbix

docker pull shut2000/gin_zabbix:latest
docker run -d  -e DB_PASS="password_db" 

Делалось по принципу "В лоб" - в одном контейнере все
Правильно сделать 
- mysql и zabbix контейнеры (images)
- добавить проброс каталогов (скрипты Zabbix, логи, файлы конфигурации)
- сделать основной image (все что не меняется или редко меняется не паковать заново) и на его основе делать установку
- сделать несколько переменных (кроме DB_PASS) для запуска Zabbix


