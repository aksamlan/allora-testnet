<h1 align="center">Allora Network Point Program</h1>

> - Keplr'da yeni bir cüzdan oluşturun
>
> - Zincir içi Nokta Programına bağlanın [Gösterge Paneli](https://app.allora.network?ref=eyJyZWZlcnJlcl9pZCI6IjJhNjMxY2VhLThkNTYtNDU0Zi1hMTQ0LTA0MzEzZDNhZjcxMSJ9)
>
> - Kampanyalar sekmesinde 2 görev görüyorsunuz, bunları kontrol edin
> 
> - Eğitimde `konu 1` ile bir `Fiyat Tahmin Çalışanı` çalıştırıyoruz (her 24 saatte bir `ETH` fiyatını tahmin etmek)
>
> - `Konu`nun ne anlama geldiğini görmek için kampanya görevleri adımlarını kontrol edin
>
> - İşçi çalıştırarak puan alıyoruz
>
> - Şu anda herkes için puan 0 ve %100 iyi olduğumuzdan emin değiliz
>
> - Burada düzenli olarak güncelleme yapacağım, böylece düzeltildiğinde puan kazanacağımızdan emin olacağız.

#

> Zincir dışı topluluk görevlerine katıldığınızdan emin olun. [Zealy](https://zealy.io/cw/alloranetwork/questboard) & [Galxe](https://app.galxe.com/quest/AlloraNetwork) zincir içi görevler kadar önemliler.


#

<h1 align="center">Fiyat Tahmin Çalışan Düğümü</h1>

## System Requirements
![image](https://github.com/0xmoei/allora-testnet/assets/90371338/56f1e0d2-4d59-436c-a0e0-183f9a082de4)

## Bağımlılıkları yükle
```console
# Install Packages
sudo apt update & sudo apt upgrade -y

sudo apt install ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev curl git wget make jq build-essential pkg-config lsb-release libssl-dev libreadline-dev libffi-dev gcc screen unzip lz4 -y
```
```console
# Install Python3
sudo apt install python3
python3 --version

sudo apt install python3-pip
pip3 --version
```
```console
# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
docker version

# Install Docker-Compose
VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)

curl -L "https://github.com/docker/compose/releases/download/"$VER"/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Docker Permission to user
sudo groupadd docker
sudo usermod -aG docker $USER
```
```console
# Install Go
cd $HOME && \
ver="1.21.3" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```

## Allorad'ı yükleyin: Cüzdan
```console
git clone https://github.com/allora-network/allora-chain.git

cd allora-chain && make all

allorad version
```

## Cüzdan ekle
* Cüzdanınızı kurtarmak veya yeni bir tane oluşturmak için keplr tohum cümlenizi kullanabilirsiniz.
```console
# Recover your wallet with seed-phrase
allorad keys add testkey --recover

#OR

# Create a new wallet
allorad keys add testkey
```

## Faucet al
> Allora'ya bağlan [dashboard](https://app.allora.network/points/campaigns) Allora adresinizi bulmak için
>
> Allora ağını Keplr'a ekleyebilirsiniz. [here](https://explorer.edgenet.allora.network/wallet/suggest)
> 
> uAllo faucet'ten al [here](https://faucet.edgenet.allora.network/)

![Screenshot_77](https://github.com/0xmoei/allora-testnet/assets/90371338/9e1d6236-ff51-48a1-a9f6-1149c842a4d0)

![Screenshot_76](https://github.com/0xmoei/allora-testnet/assets/90371338/ff27b97d-d04f-42c4-aa1b-3fb666874098)


## İşçiyi Yükle
```console
# Install
git clone https://github.com/allora-network/basic-coin-prediction-node

cd basic-coin-prediction-node

mkdir worker-data
mkdir head-data

# Give certain permissions
sudo chmod -R 777 worker-data
sudo chmod -R 777 head-data

# Create head keys
sudo docker run -it --entrypoint=bash -v ./head-data:/data alloranetwork/allora-inference-base:latest -c "mkdir -p /data/keys && (cd /data/keys && allora-keys)"

# Create worker keys
sudo docker run -it --entrypoint=bash -v ./worker-data:/data alloranetwork/allora-inference-base:latest -c "mkdir -p /data/keys && (cd /data/keys && allora-keys)"
```
```console
# Copy the head-id
cat head-data/keys/identity
```
> Bu sizin kafa kimliğiniz, bir sonraki adımda ona ihtiyacınız olacak

![Screenshot_78](https://github.com/0xmoei/allora-testnet/assets/90371338/5c8e4f77-6214-4f65-83e2-359a39aee966)

## Allora Chain'e bağlanın
* Sil ve yeni oluştur `docker-compose.yml` dosya
```console
rm -rf docker-compose.yml && nano docker-compose.yml
```

* Aşağıdaki kodu kopyalayıp içine yapıştırın
* Değiştir `head-id` & `WALLET_SEED_PHRASE`
```
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
      timeout: 5s
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
          --boot-nodes=/ip4/172.22.0.100/tcp/9010/p2p/head-id \
          --topic=1 \
          --allora-chain-key-name=testkey \
          --allora-chain-restore-mnemonic='WALLET_SEED_PHRASE' \
          --allora-node-rpc-address=https://allora-rpc.edgenet.allora.network/ \
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
Kaydet: CTRL+X+Y Enter

## İşçiyi çalıştır
```console
docker compose build
docker compose up -d
```

## Düğüm durumunuzu kontrol edin
### Çalışan liman işçisi konteynerlerini kontrol edin
```console
docker ps
```
![Screenshot_81](https://github.com/0xmoei/allora-testnet/assets/90371338/9565560a-6884-42f6-899b-7920eca43ef0)

`CONTAINER_ID`yi liman işçisi konteynerlerinizin kimliğiyle değiştirin
```console
docker logs -f CONTAINER_ID
```
> Success: register node Tx Hash:=82BF67E2E1247B226B8C5CFCF3E4F41076909ADABF3852C468D087D94BD9FC3B

![Screenshot_80](https://github.com/0xmoei/allora-testnet/assets/90371338/cefe126e-4ecb-4af3-9444-4e5e014fed52)


### Çalışan düğümünü kontrol edin:
```console
curl --location 'http://localhost:6000/api/v1/functions/execute' \
--header 'Content-Type: application/json' \
--data '{
    "function_id": "bafybeigpiwl3o73zvvl6dxdqu7zqcub5mhg65jiky2xqb4rdhfmikswzqm",
    "method": "allora-inference-function.wasm",
    "parameters": null,
    "topic": "1",
    "config": {
        "env_vars": [
            {
                "name": "BLS_REQUEST_PATH",
                "value": "/api"
            },
            {
                "name": "ALLORA_ARG_PARAMS",
                "value": "ETH"
            }
        ],
        "number_of_nodes": -1,
        "timeout": 2
    }
}'
```
Response:
```
{
  "code": "200",
  "request_id": "03001a39-4387-467c-aba1-c0e1d0d44f59",
  "results": [
    {
      "result": {
        "stdout": "{\"value\":\"2564.021586281073\"}",
        "stderr": "",
        "exit_code": 0
      },
      "peers": [
        "12D3KooWG8dHctRt6ctakJfG5masTnLaKM6xkudoR5BxLDRSrgVt"
      ],
      "frequency": 100
    }
  ],
  "cluster": {
    "peers": [
      "12D3KooWG8dHctRt6ctakJfG5masTnLaKM6xkudoR5BxLDRSrgVt"
    ]
  }
}
```

### Güncelleyici düğümünü kontrol edin:
```console
curl http://localhost:8000/update
```
Response:
```
0
```

### Çıkarım düğümünü kontrol edin:
```console
curl http://localhost:8000/inference/ETH
```
Response:
```
{"value":"2564.021586281073"}
```

### Docker konteynerlerini kontrol edin
```console
docker ps
```


Tebrikler. İşçi güvenli bir şekilde çalışıyor ancak şu anda puan sistemi hatalı göründüğünden bunu tamamen doğru yaptığımdan emin değilim. burayı güncelleyeceğim
