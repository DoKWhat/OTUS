#!/bin/bash
/usr/bin/flock /var/tmp/myscript.lock /root/script.sh > email | mail -s example.com
#При смене директории скрипта парсинга необходимо изменить строчку /root/script.sh
