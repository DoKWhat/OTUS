Скрипт для создания RAID 6:
mdadm --create --verbose /dev/md0 -l 6 -n 5 /dev/sd{b,c,d,e,f}

Конфиг. файл для сбора RAID при загрузке:
DEVICE partitions
ARRAY /dev/md0 level=raid6 num-devices=5 metadata=1.2 name=otuslinux:0 UUID=94f4f019:e7f702a0:5ca098c1:5d328786
