sudo useradd otusadm && sudo useradd otus #создаем пользователей otus otusadm
echo "Otus2022!" | sudo passwd --stdin otusadm && echo "Otus2022!" | sudo passwd --stdin otus #применяем пароли
sudo groupadd -f admin && usermod otusadm -a -G admin && usermod root -a -G admin && usermod vagrant -a -G admin #добавляем группу и в нее пользователей
vi /usr/local/bin/login.sh #создаем скрипт

!/bin/bash
#Первое условие: если день недели суббота или воскресенье
if [ $(date +%a) = "Sat" ] || [ $(date +%a) = "Sun" ]; then
 #Второе условие: входит ли пользователь в группу admin
 if getent group admin | grep -qw "$PAM_USER"; then
        #Если пользователь входит в группу admin, то он может подключиться
        exit 0
      else
        #Иначе ошибка (не сможет подключиться)
        exit 1
    fi
  #Если день не выходной, то подключиться может любой пользователь
  else
    exit 0
fi
chmod +x /usr/local/bin/login.sh #Накидываем права
В /etc/pam.d/sshd добавляем сроку
auth  required pam_exec.so /usr/local/bin/login.sh
systemctl restart sshd #на всякий случай перезапускаем SSH

