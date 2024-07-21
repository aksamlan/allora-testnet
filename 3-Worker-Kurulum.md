# Bu otomatik scripttir bundan önce varsa önceki dosyaları silinecektir ve yeniden kurulacaktır, Oluşturmuş olduğunuz cüzdan ile ilerleyebilirsiniz veya yenisini oluşturabilirsiniz.

# FAUCET [BURADAN](https://faucet.testnet-1.testnet.allora.network/) ALABİLİRSİNİZ.

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

# Eski dosyaları yokedelim.
```console
cd $HOME
rm -rf allora-chain
rm -rf basic-coin-prediction-node
```

# Scripti çalıştıralım.
```console
wget https://raw.githubusercontent.com/aksamlan/allora-testnet/main/allora-husonode.sh && chmod +x allora-husonode.sh && ./allora-husonode.sh
```

# Eğer ola ki hata ile karşılaştınız tekrar denemek için aşağıdaki kod devam edin. Hata almazsanız KULLANMAYIN.
```console
./allora-husonode.sh
```

Kurulum bittikten sonra kontrolleri yapalım. Ctrl - C ile logları durdurabilirsiniz.

# Worker 1 loglar için
```console
docker compose logs -f worker-1
```

# Worker 2 loglar için
```console
docker compose logs -f worker-2
```

# Worker 3 loglar için
```console
docker compose logs -f worker-3
```


# Workerlerin çalıştığını anlamak için aşağıdaki kodları tek tek giriniz ve kontrol ediniz. Code 200 çıktısı alırsanız okeydir.

Worker 1 için : 
```console
network_height=$(curl -s -X 'GET' 'https://allora-rpc.testnet-1.testnet.allora.network/abci_info?' -H 'accept: application/json' | jq -r .result.response.last_block_height) && \
curl --location 'http://localhost:6000/api/v1/functions/execute' --header 'Content-Type: application/json' --data '{
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
            },
            {
                "name": "ALLORA_BLOCK_HEIGHT_CURRENT",
                "value": "'"${network_height}"'"
            }
        ],
        "number_of_nodes": -1,
        "timeout": 10
    }
}' | jq
```
Worker 2 için : 
```console
network_height=$(curl -s -X 'GET' 'https://allora-rpc.testnet-1.testnet.allora.network/abci_info?' -H 'accept: application/json' | jq -r .result.response.last_block_height) && \
curl --location 'http://localhost:6000/api/v1/functions/execute' --header 'Content-Type: application/json' --data '{
    "function_id": "bafybeigpiwl3o73zvvl6dxdqu7zqcub5mhg65jiky2xqb4rdhfmikswzqm",
    "method": "allora-inference-function.wasm",
    "parameters": null,
    "topic": "2",
    "config": {
        "env_vars": [
            {
                "name": "BLS_REQUEST_PATH",
                "value": "/api"
            },
            {
                "name": "ALLORA_ARG_PARAMS",
                "value": "ETH"
            },
            {
                "name": "ALLORA_BLOCK_HEIGHT_CURRENT",
                "value": "'"${network_height}"'"
            }
        ],
        "number_of_nodes": -1,
        "timeout": 10
    }
}' | jq
```
Worker 3 için : 
```console
network_height=$(curl -s -X 'GET' 'https://allora-rpc.testnet-1.testnet.allora.network/abci_info?' -H 'accept: application/json' | jq -r .result.response.last_block_height) && \
curl --location 'http://localhost:6000/api/v1/functions/execute' --header 'Content-Type: application/json' --data '{
    "function_id": "bafybeigpiwl3o73zvvl6dxdqu7zqcub5mhg65jiky2xqb4rdhfmikswzqm",
    "method": "allora-inference-function.wasm",
    "parameters": null,
    "topic": "7",
    "config": {
        "env_vars": [
            {
                "name": "BLS_REQUEST_PATH",
                "value": "/api"
            },
            {
                "name": "ALLORA_ARG_PARAMS",
                "value": "ETH"
            },
            {
                "name": "ALLORA_BLOCK_HEIGHT_CURRENT",
                "value": "'"${network_height}"'"
            }
        ],
        "number_of_nodes": -1,
        "timeout": 10
    }
}' | jq
```
