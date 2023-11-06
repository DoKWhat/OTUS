# Резервное копирование

**Цель домашнего задания**

**Настроить стенд Vagrant с двумя виртуальными машинами: backup_server и client. (Студент самостоятельно настраивает Vagrant)
Настроить удаленный бэкап каталога /etc c сервера client при помощи borgbackup**

**Решение**

Создаем ВМ из Vagrantfile

На нашинах client и backup проделываем

```
yum install epel-release -y
yum install borgbackup -y
```
На сервере backup

```
mkdir /var/backup
useradd borg
chown borg:borg /var/backup/
ыu - borg
mkdir .ssh
touch .ssh/authorized_keys
chmod 700 .ssh
chmod 600 .ssh/authorized_keys
```
