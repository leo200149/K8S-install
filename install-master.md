# K8S Master 安裝

## 設定hostname

```sh
hostnamectl set-hostname cluster-master
service network restart
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
systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet
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
kubeadm init --pod-network-cidr 10.244.0.0/16
```

在初始化完成後會帶出如`kubeadm join --token={token} {master-ip}`的指令，直接copy到node機器上即可加入子節點就好。

---

## 安裝k8s網路 可選想要的 以下列兩個擇一安裝

### weave
```sh
kubectl apply -f https://git.io/weave-kube
```
### flannel
```sh
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml --validate=false\
```

---

## 安裝k8s Dashboard UI

```sh
kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
```

查看port
```sh
kubectl get service kubernetes-dashboard --namespace=kube-system
```

```sh
NAME                   CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes-dashboard   10.111.126.153   <nodes>       80:{nodePort}/TCP   2d
````

用`{master-ip}:{nodePort}`即可打開Dashboard UI.

---


