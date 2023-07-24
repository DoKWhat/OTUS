Vagrant-стенд для обновления ядра и создания образа системы

Описание домашнего задания
1) Обновить ядро ОС из репозитория ELRepo
2) Создать Vagrant box c помощью Packer
3) Загрузить Vagrant box в Vagrant Cloud

Выполнение задания Обновление ядра
Проверил версию ядра: uname -r 4.18.0-277.el8.x86_64
Подключил репозиторий: sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
Установил последнее ядро из репозитория: sudo yum --enablerepo elrepo-kernel install kernel-ml -y 
Обновил конфигурацию загрузчика: sudo grub2-mkconfig -o /boot/grub2/grub.cfg
Выбрал загрузку нового ядра по умолчанию: sudo grub2-set-default 0
После перезагрузки убедился что стоит новая версия ядра: uname -r 6.4.2-1.el8.elrepo.x86_64
