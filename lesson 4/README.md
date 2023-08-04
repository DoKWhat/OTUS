1) Определить алгоритм с наилучшим сжатием.

Создаём 4 пулf из двух дисков в режиме зеркала:
[root@zfs vagrant]# zpool create otus1 mirror /dev/sdb /dev/sdc
[root@zfs vagrant]# zpool create otus2 mirror /dev/sdd /dev/sde
[root@zfs vagrant]# zpool create otus3 mirror /dev/sdf /dev/sdg
[root@zfs vagrant]# zpool create otus4 mirror /dev/sdh /dev/sdi

Создаем на зеркалах алгоритмы сжатия:
[root@zfs vagrant]# zfs set compression=lzjb otus1
[root@zfs vagrant]# zfs set compression=lz4 otus2
[root@zfs vagrant]# zfs set compression=gzip-9 otus3
[root@zfs vagrant]# zfs set compression=zle otus4

Проверка:
[root@zfs vagrant]# zfs get all | grep compression
otus1  compression           lzjb                   local
otus2  compression           lz4                    local
otus3  compression           gzip-9                 local
otus4  compression           zle                    local

Скачиваем файл на все пулы:
[root@zfs vagrant]# for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done

Проверяем скачивание:
[root@zfs vagrant]# ls -l /otus*
/otus1:
total 22054
-rw-r--r--. 1 root root 40960747 Aug  2 08:09 pg2600.converter.log

/otus2:
total 17988
-rw-r--r--. 1 root root 40960747 Aug  2 08:09 pg2600.converter.log

/otus3:
total 10957
-rw-r--r--. 1 root root 40960747 Aug  2 08:09 pg2600.converter.log

/otus4:
total 40029
-rw-r--r--. 1 root root 40960747 Aug  2 08:09 pg2600.converter.log

Смотрим сколько места занимает один и тот же файл:
root@zfs vagrant]# zfs list
NAME    USED  AVAIL     REFER  MOUNTPOINT
otus1  21.6M   330M     21.6M  /otus1
otus2  17.7M   334M     17.6M  /otus2
otus3  10.8M   341M     10.7M  /otus3
otus4  39.2M   313M     39.1M  /otus4
[root@zfs vagrant]# zfs get all | grep compressratio | grep -v ref
otus1  compressratio         1.81x                  -
otus2  compressratio         2.22x                  -
otus3  compressratio         3.65x                  -
otus4  compressratio         1.00x                  -

Вывод: Лучший метод компрессии в 3 зеркале, а значит это gzip-9 

2 Определение настроек пула
Скачиваем архив: 
[root@zfs vagrant]# wget -O archive.tar.gz --no-check-certificate 'https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download'
2023-08-04 09:37:03 (15.7 MB/s) - 'archive.tar.gz' saved [7275140/7275140]
Разархивация:
[root@zfs vagrant]# tar -xzvf archive.tar.gz
zpoolexport/
zpoolexport/filea
zpoolexport/fileb
Проверка возможности импорта:
[root@zfs vagrant]# zpool import -d zpoolexport/
   pool: otus
     id: 6554193320433390805
  state: ONLINE
 action: The pool can be imported using its name or numeric identifier.
 config:

	otus                                 ONLINE
	  mirror-0                           ONLINE
	    /home/vagrant/zpoolexport/filea  ONLINE
	    /home/vagrant/zpoolexport/fileb  ONLINE

Переименовываю пул в newotus 
[root@zfs vagrant]# zpool import -d zpoolexport/ otus newotus
[root@zfs vagrant]# zpool status
  pool: newotus
 state: ONLINE
  scan: none requested
config:

	NAME                                 STATE     READ WRITE CKSUM
	newotus                              ONLINE       0     0     0
	  mirror-0                           ONLINE       0     0     0
	    /home/vagrant/zpoolexport/filea  ONLINE       0     0     0
	    /home/vagrant/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors

Запрашиваем размер, конкретные параметры:
[root@zfs vagrant]# zfs get all newotus
NAME     PROPERTY              VALUE                  SOURCE
newotus  type                  filesystem             -
newotus  creation              Fri May 15  4:00 2020  -
newotus  used                  2.04M                  -
newotus  available             350M                   -
newotus  referenced            24K                    -
newotus  compressratio         1.00x                  -
newotus  mounted               yes                    -
newotus  quota                 none                   default
newotus  reservation           none                   default
newotus  recordsize            128K                   local
newotus  mountpoint            /newotus               default
newotus  sharenfs              off                    default
newotus  checksum              sha256                 local
newotus  compression           zle                    local
newotus  atime                 on                     default
newotus  devices               on                     default
newotus  exec                  on                     default
newotus  setuid                on                     default
newotus  readonly              off                    default
newotus  zoned                 off                    default
newotus  snapdir               hidden                 default
newotus  aclinherit            restricted             default
newotus  createtxg             1                      -
newotus  canmount              on                     default
newotus  xattr                 on                     default
newotus  copies                1                      default
newotus  version               5                      -
newotus  utf8only              off                    -
newotus  normalization         none                   -
newotus  casesensitivity       sensitive              -
newotus  vscan                 off                    default
newotus  nbmand                off                    default
newotus  sharesmb              off                    default
newotus  refquota              none                   default
newotus  refreservation        none                   default
newotus  guid                  14592242904030363272   -
newotus  primarycache          all                    default
newotus  secondarycache        all                    default
newotus  usedbysnapshots       0B                     -
newotus  usedbydataset         24K                    -
newotus  usedbychildren        2.01M                  -
newotus  usedbyrefreservation  0B                     -
newotus  logbias               latency                default
newotus  objsetid              54                     -
newotus  dedup                 off                    default
newotus  mlslabel              none                   default
newotus  sync                  standard               default
newotus  dnodesize             legacy                 default
newotus  refcompressratio      1.00x                  -
newotus  written               24K                    -
newotus  logicalused           1020K                  -
newotus  logicalreferenced     12K                    -
newotus  volmode               default                default
newotus  filesystem_limit      none                   default
newotus  snapshot_limit        none                   default
newotus  filesystem_count      none                   default
newotus  snapshot_count        none                   default
newotus  snapdev               hidden                 default
newotus  acltype               off                    default
newotus  context               none                   default
newotus  fscontext             none                   default
newotus  defcontext            none                   default
newotus  rootcontext           none                   default
newotus  relatime              off                    default
newotus  redundant_metadata    all                    default
newotus  overlay               off                    default
newotus  encryption            off                    default
newotus  keylocation           none                   default
newotus  keyformat             none                   default
newotus  pbkdf2iters           0                      default
newotus  special_small_blocks  0                      default
[root@zfs vagrant]# zfs get available newotus
NAME     PROPERTY   VALUE  SOURCE
newotus  available  350M   -
[root@zfs vagrant]# zfs get readonly newotus
NAME     PROPERTY  VALUE   SOURCE
newotus  readonly  off     default
[root@zfs vagrant]# zfs get recordsize newotus
NAME     PROPERTY    VALUE    SOURCE
newotus  recordsize  128K     local
[root@zfs vagrant]# zfs get compression newotus
NAME     PROPERTY     VALUE     SOURCE
newotus  compression  zle       local
[root@zfs vagrant]# zfs get checksum newotus
NAME     PROPERTY  VALUE      SOURCE
newotus  checksum  sha256     local

3) Работа со снапшотом, поиск сообщения от преподавателя
Скачиваем файл:
[root@zfs vagrant]# wget -O otus_task2.file --no-check-certificate "https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download"
2023-08-04 09:43:36 (15.6 MB/s) - 'otus_task2.file' saved [5432736/5432736]

Восстановим файловую систему из снапшота:
[root@zfs vagrant]# zfs receive newotus/test@today < otus_task2.file

Ищем файл с именем “secret_message”:
[root@zfs vagrant]# find /newotus/test -name "secret_message" /newotus/test/task1/file_mess/secret_message
find: paths must precede expression: /newotus/test/task1/file_mess/secret_message

Смотрим что внутри:
[root@zfs vagrant]# cat /newotus/test/task1/file_mess/secret_message
https://github.com/sindresorhus/awesome
Ссылка на гитхаб.
