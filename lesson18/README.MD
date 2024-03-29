# Dockerfile

Создать свой кастомный образ nginx на базе alpine. После запуска nginx должен 
отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx).

Определите разницу между контейнером и образом.
Вывод опишите в домашнем задании.

Ответьте на вопрос: Можно ли в контейнере собрать ядро?
Собранный образ необходимо запушить в docker hub и дать ссылку на ваш
репозиторий.

**Решение**

**Установим Docker**

```
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

```
 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
* Создадим кастомный образа nginx

    * За основу взят официальный Dockerfile из репозитория nginx
    
    * Создаём страницу index.html

```
vi index.html
```
```                                        
<html>
  <body>
    <h1>DockerOtus</h1>
  </body>
</html>
```

* Добавляем инструкцию в DockerFile

```
COPY index.html /usr/share/nginx/html/
```

* Собираем образ
```
docker build -t dokwhat:nginx
```

* Запускаем образ
```
docker run -p 8080:80 --name nginx -d --rm dokwhat:nginx
```

* Запушим собранный образ на docker hub

```
docker tag
docker login -u
docker push
```

* Ссылка на репозиторий

https://hub.docker.com/layers/dokwhat/levsl/nginx/images/sha256-5b7bd3a64532f24b642bda695b2a7cad78a31ce9579ec78d98bbe18e58a1b74b?context=repo

* Ответы на вопросы

     Определите разницу между контейнером и образом
    * Разница в контейнере и образе, в отличии от RO слоев образа контейнер имеет RW слой для работы приложения
    
    Можно ли в контейнере собрать ядро?
    *По умолчанию движок Docker не позволяет загружать модуль ядра в контейнер . Тем не менее, мы можем разрешить это, запустив контейнер в привилегированном режиме. Привилегированный режим позволяет контейнеру выполнять действия, как если бы он был хостом . Для этого мы используем опцию –privileged .

