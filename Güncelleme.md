Güncellemek için aşağıdaki adımları izleyiniz.
```console
# bu komut ile allora containerlerin idleri alıyoruz.
docker ps

docker stop İD
docker rm İD
# idleri düzenleyerek allora için olanları temizliyoruz.
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
