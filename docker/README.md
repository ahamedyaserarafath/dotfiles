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
6.Load image from file
```
docker load -i <filename>.tar
```
7. Problem and solution for overlay error
```
error creating overlay mount to /var/lib/docker/overlay2/f79e6f666560777a04dbbabcd919b3cdac79cd12cb6e124d30fc44ad063a36a1/merged: invalid argument
```
```
echo '{ "storage-driver": "devicemapper" }' | sudo tee /etc/docker/daemon.json
```
8. To start the docker with uri

/usr/lib/systemd/system/docker.service -> in centos 7
```
...
ExecStart=/usr/bin/dockerd-current \
...
```
to
```
...
ExecStart=/usr/bin/dockerd-current  -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock \
...
```
```
systemctl daemon-reload
systemctl restart docker
```

9. Install docker-ce with upgrade in centos 7
```
yum remove docker docker-common docker-selinux docker-engine
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce
docker --version
```
10. Install docker-ce with proxy and To start the docker with uri

/usr/lib/systemd/system/docker.service
```
...
[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
...
```
to
```
...
[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
Environment="http://user01:password@10.10.10.10:8080"
Environment="https://user01:password@10.10.10.10:8080"
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock  -H fd:// --containerd=/run/containerd/containerd.sock
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
...
sudo systemctl daemon-reload
sudo systemctl restart docker.service
```
11. Install latest docker compose
```
COMPOSEVERSION=$(curl -s https://github.com/docker/compose/releases/latest/download 2>&1 | grep -Po [0-9]+\.[0-9]+\.[0-9]+)
curl -L "https://github.com/docker/compose/releases/download/$COMPOSEVERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
12. Reinstall docker by removing every container
```
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi -f $(docker images -q)
yes y | docker system prune
yes y | docker system prune --volumes
sudo yum remove docker* docker-common docker-selinux docker-engine
# In case if the above command doesnt remove every docker
sudo yum remove -y docker-ce docker-ce-cli docker-common docker-selinux docker-engine
rm -rf /var/lib/docker*
rm -rf /etc/docker/
rm -rf /var/run/docker/
ip link del docker0
yum install docker-ce
```
13. To get a container ip
```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
```

14. Portainer tool is better one for managing the docker without kube.
```
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
```
