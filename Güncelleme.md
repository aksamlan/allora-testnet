Güncellemek için aşağıdaki adımları izleyiniz.
```console
docker rm -f $(docker ps -a -q);docker system prune --volumes -a -f
```

Aşağıdaki docker yaml dosyasına girip içierisinde --topic=1 olan yeri --topic=allora-topic-1-worker olarak güncellememiz gerekiyor.
```console
cd basic-coin-prediction-node
nano docker-compose.yml
```

Şimdi işçimizi tekrar çalıştırabiliriz.
```console
docker compose build
docker compose up -d
```
