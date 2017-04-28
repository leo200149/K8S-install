# K8S Master 安裝

## 設定hostname

```sh
hostnamectl set-hostname cluster-master
service network restart
sed -i "127.0.0.1  cluster-master" /etc/hosts
```

----

## 安裝K8S

```sh
yum update -y

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y docker kubelet kubeadm kubectl kubernetes-cni
```

## 補上kubeadm.conf

```sh
vi /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
```

加入`KUBELET_EXTRA_ARGS`並存檔

```sh
Environment="KUBELET_EXTRA_ARGS=--cgroup-driver=systemd"
```

## 啟動服務

```sh
systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet
sysctl -w net.bridge.bridge-nf-call-iptables=1
sysctl -w net.bridge.bridge-nf-call-ip6tables=1
```

---

## 關閉SELinux(練習用不管OS層權限才關，正式需自行找設定方式)

```sh
vi /etc/sysconfig/selinux
```

找到`SELINUX` 並設為 `SELINUX=disabled`

---

## 關閉防火牆(練習用不管OS層權限才關，正式需自行找設定方式)

```sh
systemctl disable firewalld
systemctl stop firewalld
```

---

## 使用kubeadm工具進行master節點初始化

```sh
kubeadm init --kubernetes-version=v1.6.1 --pod-network-cidr=10.244.0.0/16 \
--apiserver-advertise-address={master-ip}
```

`{master-ip}`請自行替換



## 將自動產生的key放到家目錄下，並為了kubectl訪問apiserver，在~/.bash_profile中追加上環境參數KUBECONFIG：

```sh
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
echo "export KUBECONFIG=$HOME/admin.conf" >> ~/.bash_profile
source ~/.bash_profile
```

在初始化完成後會帶出如`kubeadm join --token={token} {master-ip}`的指令，直接copy到node機器上即可加入子節點就好。

---

## 安裝k8s網路(一定要裝)，可選想要的，以下為flannel的安裝方式，1.6版新增rbac驗證，要先建立一個角色。

### flannel

```sh
kubectl create -f kube-flannel-rbac.yml
kubectl apply -f kube-flannel.yml
```

線上的

```sh
kubectl create -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

## 使master參與負載(測試環境)

```sh
kubectl taint nodes --all  node-role.kubernetes.io/master-
```

---

## 安裝k8s Dashboard UI

```sh
kubectl create -f kube-dashboard-rbac.yml
kubectl create -f kubernetes-dashboard.yaml
kubectl create -f kubernetes-dashboard-service.yaml
```

線上的

```sh
kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
```

查看port
```sh
kubectl get service kubernetes-dashboard --namespace=kube-system

NAME                   CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes-dashboard   10.111.126.153   <nodes>       80:{nodePort}/TCP   1m
kubernetes-dashboard-port   10.111.126.154   <nodes>       80:31795/TCP   1m
```

用`{master-ip}:31795` 或 `{master-ip}:{nodePort}`即可打開Dashboard UI.

---

## 安裝Heapster 為Dashboard增加統計及監控(使用InfluxDB)

```sh
wget https://github.com/kubernetes/heapster/archive/v1.3.0.tar.gz
tar -zxvf v1.3.0.tar.gz
kubectl create -f heapster-1.3.0/deploy/kube-config/influxdb/
```

