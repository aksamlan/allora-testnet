# Güncellemek için dosyalarımızın içine girelim.
```console
cd allora-chain && cd basic-coin-prediction-node
```

 YÖNTEM 1 - (EĞER TEK ALLORA ÇALISIYORSA* )BU KOD DOCKER PS İÇERİSİNDEKİ TÜM DOCKERLERİ SİLECEKTİR ONA GÖRE YAPINIZ.EĞER BAŞKA DOCKER İLE ÇALIŞAN PROJE VARSA TEKRAR ÇALIŞTIRMANIZ GEREKİYOR.
```console
docker rm -f $(docker ps -a -q) && docker system prune --volumes -a -f
```

 YÖNTEM 2 - (EĞER FARKLI PROJELER ÇALIŞIYORSA DOCKER İLE BU KODLAR İLE KONTROL EDİN VE TEK TEK SİLİNİZ)*
```console
docker ps -a
```
 Karşınıza liste çıkacak ordan Allora'ya ait olanları 1. durdurup 2. silmesi için uygulayın.
```console
docker stop containerIDsi
```
```console 
docker rm containerIDsi
```

 İşlemleri yaptıktan sonra HEAD-ID kontrolü yapıyoruz ve not almadıysak bu kod ile alıyoruz.
```console
cat head-data/keys/identity
```

 Containerleri sildiysek yolumuza devam ediyoruz, eski docker compose silip temizini ekliyor ve içini düzeltmek için iki aşağıdaki kodları temiz docker composeye ekliyoruz.
```console
rm -rf docker-compose.yml && nano docker-compose.yml
```
 `HEAD-ID` ve `CÜZDAN-KELİMELERİ` kısımlarını kendinize göre düzenliyorsunuz ve üstteki komutta açtığımız dosyanın içine atıyoruz. Sonra CTRL X - Y Enter. kaydediyoruz. 
```console
version: '3'

services:
  inference:
    container_name: inference-basic-eth-pred
    build:
      context: .
    command: python -u /app/app.py
    ports:
      - "8000:8000"
    networks:
      eth-model-local:
        aliases:
          - inference
        ipv4_address: 172.22.0.4
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/inference/ETH"]
      interval: 10s
      timeout: 10s
      retries: 12
    volumes:
      - ./inference-data:/app/data

  updater:
    container_name: updater-basic-eth-pred
    build: .
    environment:
      - INFERENCE_API_ADDRESS=http://inference:8000
    command: >
      sh -c "
      while true; do
        python -u /app/update_app.py;
        sleep 24h;
      done
      "
    depends_on:
      inference:
        condition: service_healthy
    networks:
      eth-model-local:
        aliases:
          - updater
        ipv4_address: 172.22.0.5

  worker:
    container_name: worker-basic-eth-pred
    environment:
      - INFERENCE_API_ADDRESS=http://inference:8000
      - HOME=/data
    build:
      context: .
      dockerfile: Dockerfile_b7s
    entrypoint:
      - "/bin/bash"
      - "-c"
      - |
        if [ ! -f /data/keys/priv.bin ]; then
          echo "Generating new private keys..."
          mkdir -p /data/keys
          cd /data/keys
          allora-keys
        fi
        # Change boot-nodes below to the key advertised by your head
        allora-node --role=worker --peer-db=/data/peerdb --function-db=/data/function-db \
          --runtime-path=/app/runtime --runtime-cli=bls-runtime --workspace=/data/workspace \
          --private-key=/data/keys/priv.bin --log-level=debug --port=9011 \
          --boot-nodes=/ip4/172.22.0.100/tcp/9010/p2p/HEAD-ID-BURAYA-GİRİYORUZ \
          --topic=allora-topic-1-worker \
          --allora-chain-key-name=testkey \
          --allora-chain-restore-mnemonic='CÜZDAN-KEYLERİNİ-BURAYA-GİRİYORUZ' \
          --allora-node-rpc-address=https://allora-rpc.testnet-1.testnet.allora.network/ \
          --allora-chain-topic-id=1
    volumes:
      - ./worker-data:/data
    working_dir: /data
    depends_on:
      - inference
      - head
    networks:
      eth-model-local:
        aliases:
          - worker
        ipv4_address: 172.22.0.10

  head:
    container_name: head-basic-eth-pred
    image: alloranetwork/allora-inference-base-head:latest
    environment:
      - HOME=/data
    entrypoint:
      - "/bin/bash"
      - "-c"
      - |
        if [ ! -f /data/keys/priv.bin ]; then
          echo "Generating new private keys..."
          mkdir -p /data/keys
          cd /data/keys
          allora-keys
        fi
        allora-node --role=head --peer-db=/data/peerdb --function-db=/data/function-db  \
          --runtime-path=/app/runtime --runtime-cli=bls-runtime --workspace=/data/workspace \
          --private-key=/data/keys/priv.bin --log-level=debug --port=9010 --rest-api=:6000
    ports:
      - "6000:6000"
    volumes:
      - ./head-data:/data
    working_dir: /data
    networks:
      eth-model-local:
        aliases:
          - head
        ipv4_address: 172.22.0.100


networks:
  eth-model-local:
    driver: bridge
    ipam:
      config:
        - subnet: 172.22.0.0/24

volumes:
  inference-data:
  worker-data:
  head-data:
```
# Faucet [BURADAN](https://faucet.testnet-1.testnet.allora.network/) alıyoruz ve geldiğikten sonra aşağıdaki kodlarla ilerliyoruz.
```console
docker compose build
docker compose up -d
```

 Log kontrolü için [BURADAKI](https://github.com/aksamlan/allora-testnet?tab=readme-ov-file#d%C3%BC%C4%9F%C3%BCm-durumunuzu-kontrol-edin) adımları izleyerek kontol ediyoruz. Eğer doğru çalışırsa bu şekilde olacaktır.
 Eğer Balance hatası alırsanız 2. kez faucetten token alın ya da RPC hatası alırsanız aşağıdaki kodlar ile ilerleyip tekrar logları kontrol edin. Bunları yaparken `cd basic-coin-prediction-node` bu klasörde olduğunuzdan emin olun.
```console
docker compose down
docker compose up -d
```

