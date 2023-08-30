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


Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно также называться

yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y

vi /etc/sysconfig/spawn-fcgi

vi /etc/systemd/system/spawn-fcgi.service

systemctl start spawn-fcgi

systemctl status spawn-fcgi

![image](https://github.com/DoKWhat/OTUS/assets/44500660/e2ed0eed-38b2-448c-b21e-4054a430d88d)

vi /usr/lib/systemd/system/httpd.service
vi /etc/sysconfig/httpd-first
vi /etc/sysconfig/httpd-second

vi /etc/httpd/conf/first.conf
vi /etc/httpd/conf/second.conf


Дополнить init-файл apache httpd возможностью зупаскать несколько инстансов сервера с разными конфигами

![image](https://github.com/DoKWhat/OTUS/assets/44500660/e71e1608-10b6-4806-8c65-081fc010292c)
