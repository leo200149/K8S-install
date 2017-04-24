# K8S Node 安裝(一般建議至少裝2個node以上)

## 設定hostname

```sh
hostnamectl set-hostname cluster-node-{id}
service network restart
sed -i "127.0.0.1  cluster-node-{id}" /etc/hosts
```

`{id}`請自行替換

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

## 關閉防火牆(練習用不管OS層權限才關，正式需自行找設定方式)

```sh
systemctl disable firewalld
systemctl stop firewalld
```

---

## 使用kubeadm工具進行node節點初始化

```sh
kubeadm join --token={token} {ip}
```

在master初始化完成後會帶出如上的指令，直接copy到node機器上貼上就好。

## 檢查是否加入成功

到master上執行以下指令

```sh
kubectl get nodes
```

結果如下即為加入成功
```sh
NAME             STATUS         AGE
cluster-master   Ready,master   
cluster-node{id}    Ready          
......
```
