1.Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig
Решение:
vi /etc/sysconfig/watchlog
cat /etc/sysconfig/watchlog
![image](https://github.com/DoKWhat/OTUS/assets/44500660/a044c75c-959b-451f-920a-456a05f80de7)

Создадим скрипт:
vi /opt/watchlog.sh
cat /opt/watchlog.sh
![image](https://github.com/DoKWhat/OTUS/assets/44500660/052e919a-19b8-4e99-9525-41136d8ca95e)

chmod +x /opt/watchlog.sh
cd etc/systemd/system/
vi watchlog.service
vi watchlog.timer
systemctl start watchlog.timer
tail -f /var/log/messages
Результат выполнения сервиса
![image](https://github.com/DoKWhat/OTUS/assets/44500660/1f9513b6-30b3-46d8-9448-82fd7b40c334)


Переписать init-скрипт на unit-файл в spawn-fcgi.
![image](https://github.com/DoKWhat/OTUS/assets/44500660/8ef3a9e6-6144-4da9-9b6a-0930b3a085c7) 

Дополнить init-файл apache httpd возможностью зупаскать несколько инстансов сервера с разными конфигами

![image](https://github.com/DoKWhat/OTUS/assets/44500660/e71e1608-10b6-4806-8c65-081fc010292c)
