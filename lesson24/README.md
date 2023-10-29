# Сбор и анализ логов

**Цель домашнего задания**

Научится проектировать централизованный сбор логов. Рассмотреть особенности разных платформ для сбора логов.

**Описание домашнего задания**

* В Vagrant разворачиваем 2 виртуальные машины web и log
* На web настраиваем nginx
* На log настраиваем центральный лог сервер на любой системе на выбор
    * journald
    * rsyslog
    * elk
* Настраиваем аудит, следящий за изменением конфигов nginx 

Все критичные логи с web должны собираться и локально и удаленно.
Все логи с nginx должны уходить на удаленный сервер (локально только критичные).
Логи аудита должны также уходить на удаленную систему.

Формат сдачи ДЗ - vagrant + ansible

* Дополнительное задание
    * развернуть еще машину с elk
    * таким образом настроить 2 центральных лог системы elk и какую либо еще;
    * в elk должны уходить только логи нжинкса;
    * во вторую систему все остальное.

**Решение**

Создаем ВМ из Vagrantfile

Настраиваем одинаковое время на машинах web и log

```
vagrant ssh web
sudo -i
cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime
systemctl restart chronyd
systemctl status chronyd

vagrant ssh log
sudo -i
cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime
systemctl restart chronyd
systemctl status chronyd

```
![Alt text](1.png)
![Alt text](2.png)

**Установка, настрйока и проверка работы nginx**

```
yum install epel-release
yum install -y nginx
systemctl start nginx
```

Проверяем работу nginx попыткой зайти на веб

![Alt text](3.png)

**Настройка центрального сервера сбора логов**

```
vagrant ssh log
sudo -i
nano /etc/rsyslog.conf
```

![Alt text](4.png)
![Alt text](5.png)

```
systemctl restart rsyslog
```

**Настройка отправки логов с web-сервера**

```
vagrant ssh web
sudo -i
nano /etc/nginx/nginx.conf
```

![Alt text](6.png)

Проверяем сыпятся ли ошибки - удаляем картинку, к которой обращается nginx, пытаемся обратиться, смотрим логи
```
systemctl restart nginx
rm /usr/share/nginx/html/img/header-background.png
cat /var/log/rsyslog/web/nginx_access.log
```
![Alt text](7.png)

**Настройка аудита, контролирующего изменения конфигурации nginx**

```
nano /etc/audit/rules.d/audit.rules
```
![Alt text](8.png)

```
service auditd restart
```
Проверяем локальную запись логов
![Alt text](9.png)
```
yum -y install audispd-plugins
nano /etc/audit/auditd.conf
```
![Alt text](10.png)
```
nano /etc/audisp/plugins.d/au-remote.conf
nano /etc/audisp/audisp-remote.conf
service auditd restart
```
![Alt text](11.png)
![Alt text](12.png)

```
vagrant ssh log
nano /etc/audit/auditd.conf
service auditd restart
```
![Alt text](13.png)
```
ls -l /etc/nginx/nginx.conf
chmod +x /etc//nginx/nginx.conf
ls -l /etc/nginx/nginx.conf
```
![Alt text](14.png)
![Alt text](15.png)
