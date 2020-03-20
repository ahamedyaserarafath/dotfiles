docker installation in ubuntu 18.04
```
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
```

docker push to hub.docker.com
```
sudo docker login
sudo docker images
sudo docker tag 29aed937c265 ahamedyaserarafath/mongodb:<tag_name>
sudo docker push ahamedyaserarafath/mongodb:<tag_name>
```

Some useful commands
1. to clean system images which occupied the disk
```
docker system prune
```
