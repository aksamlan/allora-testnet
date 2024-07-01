Güncellemek için aşağıdaki adımları izleyiniz.
```console
cd basic-coin-prediction-node
docker compose down
```

Aşağıdaki docker yaml dosyasına girip içierisinde --topic=1 olan yeri --topic=allora-topic-1-worker olarak güncellememiz gerekiyor.
```console
nano docker-compose.yml
```

Şimdi işçimizi tekrar çalıştırabiliriz.
```console
docker compose build
docker compose up -d
```
