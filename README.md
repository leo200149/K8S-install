# K8S(kubernetes) 安裝練習

## 資源

1. [https://kubernetes.io/docs/user-guide/](https://kubernetes.io/docs/user-guide/)
2. [http://k8s.bingohuang.com/](http://k8s.bingohuang.com/)
3. [https://www.centos.org/download/](https://www.centos.org/download/)

---

## 步驟

1. 準備OS:Centos7 多台(可用VM)
2. 安裝kubernetes master-[install-master.md](install-master.md)
3. 安裝kubernetes node-[install-node.md](install-node.md)
4. 佈署app container至kuberneetes-[install-deploy.md](install-deploy.md)
5. 範例可用[kafka](kafka),[redis](redis)(clone後執行shell檔)
6. 安裝gluster-kubernetes 做為`volumes` 供app掛載使用-[volumes folder](volumes)

---
