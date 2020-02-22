Install Kubernetes on a CentOS 7 server.

**Note Commands 1-10 need to be run on all nodes.

*In this we are using 3 unit servers as this meets the minimum requirements for the Kubernetes installation. 
Use of a smaller size server (less than 2 cpus) will result in errors during installation.

1. The first thing that we are going to do is use SSH to log in to all machines. 
Once we have logged in, we need to elevate privileges using sudo.
```
sudo su
```
2. Disable SELinux.
```
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
```
3. Enable the br_netfilter module for cluster communication.
```
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
```
4. Disable swap to prevent memory allocation issues.
```
    swapoff -a
    vim /etc/fstab.orig  ->  Comment out the swap line
```
5. Install the Docker prerequisites.
```
    yum install -y yum-utils device-mapper-persistent-data lvm2
```   
6. Add the Docker repo and install Docker.
```
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install -y docker-ce
```    
7. Configure the Docker Cgroup Driver to systemd, enable and start Docker
```
    sed -i '/^ExecStart/ s/$/ --exec-opt native.cgroupdriver=systemd/' /usr/lib/systemd/system/docker.service 
    systemctl daemon-reload
    systemctl enable docker --now 
    systemctl status docker
    docker info | grep -i cgroup
```    
8. Add the Kubernetes repo.
```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
      https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```
9. Install Kubernetes.
```
    yum install -y kubelet kubeadm kubectl
```    
10. Enable Kubernetes. The kubelet service will not start until you run kubeadm init.
```
    systemctl enable kubelet
```    
*Note: Complete the following section on the MASTER ONLY!

11. Initialize the cluster using the IP range for Flannel.
```
    kubeadm init --pod-network-cidr=10.244.0.0/16
```
Ignore the cpu check
```
    kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU
```  
12. Copy the kubeadmin join command.

13. Exit sudo and run the following:
```
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
```    
14. Deploy Flannel.
```
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```    
16. Check the cluster state.
```
    kubectl get pods --all-namespaces
```    
*Note: Complete the following steps on the NODES ONLY!

17. Run the join command that you copied earlier (this command needs to be run as sudo), then check your nodes from the master.
```
kubectl get nodes
```


Sample Yaml File
```
apiVersion: v1
kind: Pod
metadata:
  name: examplepod
  namespace: podexample
spec:
  volumes:
  - name: html
    emptyDir: {}
  containers:
  - name: webcontainer
    image: nginx
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html
  - name: filecontainer
    image: debian
    volumeMounts:
    - name: html
      mountPath: /html
    command: ["/bin/sh", "-c"]
    args:
      - while true; do
         date >> /html/index.html;
         sleep 1;
        done
```

Sample replica yaml file
```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
  labels:
    app: nginx
    tier: frontend
spec:
  replicas: 2
  selector:
    matchLabels: 
      tier: frontend
    matchExpressions:
      - {key: tier, operator: In, values: [frontend]}
  template:
    metadata:
      labels:
        app: nginx
        tier: frontend
    spec:
      containers:
      - name: nginx
        image: darealmc/nginx-k8s:v1
        ports:
        - containerPort: 80
```
Sample service yaml file

```
kind: Service
apiVersion: v1
metadata:
  name: my-awesome-service
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 32768
    targetPort: 80
```
Sample deployment yaml file

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-deployment 
  labels: 
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx 
    spec: 
      containers:
      - name: nginx
        image: darealmc/nginx-k8s:v1
        ports:
        - containerPort: 80
```
change the image in deployment
```
kubectl set image deployment.v1.apps/example-deployment nginx=darealmc/nginx-k8s:v2
```
Kubernets dashboard
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
```
```
kubectl proxy --address='0.0.0.0'
```
