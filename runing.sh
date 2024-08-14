#!/bin/bash

# Önceki cüzdan mnemonic kelimeleri giriniz
read -p "Enter your mnemonic phrase: " mnemonic_phrase

# Repoyu Clonluyoruz
git clone https://github.com/allora-network/basic-coin-prediction-node

# Dizini değiştir
cd basic-coin-prediction-node

# JSON içeriğini config.json'a yazın
cat <<EOF > config.json
{
  "wallet": {
    "addressKeyName": "test",
    "addressRestoreMnemonic": "$mnemonic_phrase",
    "alloraHomeDir": "",
    "gas": "1000000",
    "gasAdjustment": 1.0,
    "nodeRpc": "https://sentries-rpc.testnet-1.testnet.allora.network/",
    "maxRetries": 1,
    "delay": 1,
    "submitTx": false
  },
  "worker": [
    {
      "topicId": 1,
      "inferenceEntrypointName": "api-worker-reputer",
      "loopSeconds": 5,
      "parameters": {
        "InferenceEndpoint": "http://inference:8000/inference/{Token}",
        "Token": "ETH"
      }
    },
    {
      "topicId": 2,
      "inferenceEntrypointName": "api-worker-reputer",
      "loopSeconds": 5,
      "parameters": {
        "InferenceEndpoint": "http://inference:8000/inference/{Token}",
        "Token": "ETH"
      }
          },
    {
      "topicId": 3,
      "inferenceEntrypointName": "api-worker-reputer",
      "loopSeconds": 7,
      "parameters": {
        "InferenceEndpoint": "http://inference:8000/inference/{Token}",
        "Token": "BTC"
      }
          },
    {
      "topicId": 4,
      "inferenceEntrypointName": "api-worker-reputer",
      "loopSeconds": 7,
      "parameters": {
        "InferenceEndpoint": "http://inference:8000/inference/{Token}",
        "Token": "BTC"
      }
                },
    {
      "topicId": 5,
      "inferenceEntrypointName": "api-worker-reputer",
      "loopSeconds": 8,
      "parameters": {
        "InferenceEndpoint": "http://inference:8000/inference/{Token}",
        "Token": "SOL"
      }
          },
    {
      "topicId": 6,
      "inferenceEntrypointName": "api-worker-reputer",
      "loopSeconds": 8,
      "parameters": {
        "InferenceEndpoint": "http://inference:8000/inference/{Token}",
        "Token": "SOL"
      }
    }
  ]
}
EOF

echo "Belirtilen içerikle oluşturulan yapılandırma dosyası."

mkdir worker-data
chmod +x init.config
./init.config 

# Docker containers calistiralim
docker-compose up -d
