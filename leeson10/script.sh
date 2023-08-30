#!/bin/bash
var=$(ex -s +1p +q 2.txt)
echo "Временный диапазон"
awk -v m=$var 'NR>m' access-4560-644067.log | awk '{print $4}' | head -n 1 &&  date
#1
echo "Список IP адресов"
awk -v m=$var 'NR>m' access-4560-644067.log | awk '{print $1}' | sort | uniq -c | sort -rn
echo "------------------------------------------------------"
#2
echo "Список URL"
awk -v m=$var 'NR>m' access-4560-644067.log | awk '{print $11}' | sort | uniq -c | sort -rn
#echo "------------------------------------------------------"
#3
echo "Ошибки HTTP" # Исхожу из того, что ошибки веб серверва начинаются с 5
awk -v m=$var 'NR>m' access-4560-644067.log | awk '{print $9}' | grep '5.' | sort | uniq -c | sort -rn
echo "------------------------------------------------------"
#4
echo 'Коды HTTP' #Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипт. Исхожу из того, что нужны коды 1-4
awk -v m=$var 'NR>m' access-4560-644067.log | awk '{print $9}' | grep "[1-4]" | sort | uniq -c | sort -rn
wc -l < access-4560-644067.log > 2.txt
echo "all"
