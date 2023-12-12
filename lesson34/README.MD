# VPN

**Цель домашнего задания**

- Между двумя виртуалками поднять vpn в режимах:
  - tun
  - tap

Описать в чём разница, замерить скорость между виртуальными машинами в туннелях, сделаь вывод об отличающихся показателях скорости.

- Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку

**Решение**

## TUN/TAP режимы VPN

### После запуска машин из Vagrantfile выполняем следующие действия на server и client машинах

- устанавливаем epel репозиторий

```bash
dnf install -y epel-release
```

- устанавливаем пакет openvpn, easy-rsa и iperf3

```bash
dnf install -y openvpn iperf3
```

- Отключаем SELinux и firewalld (без его отключения не работает у меня)

```bash
setenforce 0
service firewalld stop
```



### Настройка openvpn сервера

- создаем файл ключ

```bash
openvpn --genkey --secret /etc/openvpn/static.key
```

- создаём конфигурационный файл vpn-сервера

```bash
vi /etc/openvpn/server.conf

dev tap
ifconfig 10.10.10.1 255.255.255.0
topology subnet
secret /etc/openvpn/static.key
comp-lzo
status /var/log/openvpn-status.log
log /var/log/openvpn.log
verb 3
```

- Запускаем openvpn сервер и добавлāем в автозагрузку

```bash
systemctl start openvpn@server
systemctl enable openvpn@server
```

### Настройка openvpn клиента

```bash
vi /etc/openvpn/server.conf

dev tap
remote 192.168.56.10
ifconfig 10.10.10.2 255.255.255.0
topology subnet
route 192.168.56.0 255.255.255.0
secret /etc/openvpn/static.key
comp-lzo
status /var/log/openvpn-status.log
log /var/log/openvpn.log
verb 3
```

- На сервер клиента в директории /etc/openvpn/ скопируем файл-ключ static.key, который был создан на сервере

- Запускаем openvpn клиент и добавляем в автозагрузку

```bash
systemctl start openvpn@server
systemctl enable openvpn@server
```

### Далее необходимо замерить скорость в туннеле

- на openvpn сервере запускаем iperf3 в режиме сервера

```bash
iperf3 -s &
```

- на openvpn клиенте запускаем iperf3 в режиме клиента и замеряем скорость в туннеле

```bash
iperf3 -c 10.10.10.1 -t 40 -i 5
Connecting to host 10.10.10.1, port 5201
[  5] local 10.10.10.2 port 46972 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-5.00   sec   101 MBytes   170 Mbits/sec   41   94.2 KBytes       
[  5]   5.00-10.00  sec  99.0 MBytes   166 Mbits/sec   47    107 KBytes       
[  5]  10.00-15.00  sec  98.5 MBytes   165 Mbits/sec   53    112 KBytes       
[  5]  15.00-20.00  sec  99.9 MBytes   168 Mbits/sec   54   98.0 KBytes       
[  5]  20.00-25.00  sec  99.8 MBytes   167 Mbits/sec   45   85.1 KBytes       
[  5]  25.00-30.00  sec   101 MBytes   169 Mbits/sec   76   82.6 KBytes       
[  5]  30.00-35.00  sec   102 MBytes   170 Mbits/sec   97    101 KBytes       
[  5]  35.00-40.00  sec   102 MBytes   172 Mbits/sec   50   82.6 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-40.00  sec   803 MBytes   168 Mbits/sec  463             sender
[  5]   0.00-40.03  sec   802 MBytes   168 Mbits/sec                  receiver

iperf Done.

```

### Повторяем пункты 1-5 для режима работы tun. Конфигурационные файлы сервера и клиента изменяться только в директиве dev. Делаем выводы о режимах, их достоинствах и недостатках

```bash
[root@client ~]# iperf3 -c 10.10.10.1 -t 40 -i 5
Connecting to host 10.10.10.1, port 5201
[  5] local 10.10.10.2 port 46976 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-5.00   sec   112 MBytes   188 Mbits/sec   83   97.8 KBytes       
[  5]   5.00-10.00  sec   101 MBytes   170 Mbits/sec   70   93.8 KBytes       
[  5]  10.00-15.00  sec   101 MBytes   169 Mbits/sec   55    114 KBytes       
[  5]  15.00-20.00  sec   101 MBytes   169 Mbits/sec   80    115 KBytes       
[  5]  20.00-25.00  sec   103 MBytes   173 Mbits/sec   54    112 KBytes       
[  5]  25.00-30.00  sec   103 MBytes   174 Mbits/sec   58    107 KBytes       
[  5]  30.00-35.00  sec   101 MBytes   169 Mbits/sec   73    137 KBytes       
[  5]  35.00-40.00  sec   101 MBytes   169 Mbits/sec   71   84.6 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-40.00  sec   823 MBytes   173 Mbits/sec  544             sender
[  5]   0.00-40.06  sec   823 MBytes   172 Mbits/sec                  receiver
```

## RAS на базе OpenVPN

Для выполнения данного задания можно восполязоваться Vagrantfile из 1 задания, только убрать 1 ВМ.

### После запуска ВМ отключаем SELinux или создаём правило для него

```bash
setenforce 0
```

### Устанавливаем репозиторий EPEL

```bash
dnf install -y epel-release
```

### Устанавливаем необходимые пакеты

```bash
dnf install -y openvpn easy-rsa
```

### Переходим в директорию /etc/openvpn/ и инициализируем pki

```bash
cd /etc/openvpn/
/usr/share/easy-rsa/3.0.8/easyrsa init-pki
```

### Сгенерируем необходимые ключи и сертификаты для сервера

```bash
echo 'rasvpn' | /usr/share/easy-rsa/3.0.8/easyrsa build-ca nopass
echo 'rasvpn' | /usr/share/easy-rsa/3.0.8/easyrsa gen-req server nopass
echo 'yes' | /usr/share/easy-rsa/3.0.8/easyrsa sign-req server server
/usr/share/easy-rsa/3.0.8/easyrsa gen-dh
openvpn --genkey --secret ta.key
```

### Сгенерируем сертификаты для клиента

```bash
echo 'client' | /usr/share/easy-rsa/3.0.8/easyrsa gen-req client nopass
echo 'yes' | /usr/share/easy-rsa/3.0.8/easyrsa sign-req client client
```

### Создадим конфигурационный файл /etc/openvpn/server.conf

```bash
port 1207
proto udp
dev tun
ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/server.crt
key /etc/openvpn/pki/private/server.key
dh /etc/openvpn/pki/dh.pem
server 10.10.10.0 255.255.255.0
#route 192.168.56.0 255.255.255.0
push "route 192.168.56.0 255.255.255.0"
ifconfig-pool-persist ipp.txt
client-to-client
client-config-dir /etc/openvpn/client
keepalive 10 120
comp-lzo
persist-key
persist-tun
status /var/log/openvpn-status.log
log /var/log/openvpn.log
verb 3
```

### Зададим параметр iroute для клиента

```bash
echo 'iroute 192.168.56.0 255.255.255.0' > /etc/openvpn/client/client
```

### Запускаем openvpn сервер и добавляем в автозагрузку

```bash
systemctl start openvpn@server
systemctl enable openvpn@server
```

### Скопируем следующие файлы сертификатов и ключ для клиента на хостмашину

```bash
/etc/openvpn/pki/ca.crt
/etc/openvpn/pki/issued/client.crt
/etc/openvpn/pki/private/client.key
```

### Создадим конфигурационный файл клиента client.conf на хост-машине

```bash
dev tun
proto udp
remote 192.168.56.10 1207
client
resolv-retry infinite
ca ./ca.crt
cert ./client.crt
key ./client.key
#route 192.168.56.0 255.255.255.0
persist-key
persist-tun
comp-lzo
verb 3
```

В этом конфигурационном файле указано, что файлы сертификатов располагаются в директории, где располагается client.conf. Но при желании можно разместить сертификаты в других директориях и в конфиге скорректировать пути.

### После того, как все готово, подключаемся к openvpn сервер с хост-машины

```bash
openvpn --config client.conf
```

