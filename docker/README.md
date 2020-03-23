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
2. To use docker with proxy
```
#cat /etc/sysconfig/docker
HTTP_PROXY="http://user01:password@10.10.10.10:8080"
HTTPS_PROXY="https://user01:password@10.10.10.10:8080"
# service docker restart

```
3. to start container
```
docker container run -it -d 8b0ff41a2f76
```
4. to enter into container
```
docker container exec -it 51fef2530dd3 '/bin/bash'
```
5. Save image locally
```
docker save -o <dir>/<filename>.tar <image_name>
```
6.
