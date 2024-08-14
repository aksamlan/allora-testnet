Allora için Worker Kurulumu. Daha öncekileri siliyoruz ve bunlarla ilerliyoruz.

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

# BURADAN İTİBAREN YENİ KURULUM BAŞLIYOR.

Yüklemediyseniz ilk önce sistem için gerekli güncellemeleri ve dosyaları indirelim.
```console
sudo apt update && sudo apt upgrade -y
sudo apt install jq

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
docker version

# install docker-compose
VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)

curl -L "https://github.com/docker/compose/releases/download/"$VER"/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

# WORKER'I ÇALIŞTIRMAK İÇİN TEK KOD İLE İLERLİYORUZ. CÜZDAN KELİMELERİ GİRDİKTEN SONRA DEVAM. İÇERİSİNDE TOKEN YOKSA FAUCETTEN TOKEN ALINIZ.
```console
curl -LOs https://raw.githubusercontent.com/aksamlan/allora-testnet/main/runing.sh && chmod +x runing.sh && bash ./runing.sh
```

# Logları kontrol etmek için
```console
docker logs -f worker
```

