# gk-deploy 執行步驟拆分

可以對照執行的log看，如果有失敗才知道要從哪開始找問題
目錄:gluster-kubernetes/deploy/kube-templates

參考:[gluster-kubernetes-demo](https://drive.google.com/file/d/0B667S2caJiy7QVpzVVFNQVdyaVE/view)

## 建立service-account

```sh
$ kubectl create -f serviceaccount heketi-service-account.yaml --namespace=gluster

serviceaccount "heketi-service-account" created
clusterrolebinding "heketi-sa-view" created
```

## 獎k8s所有節點新增label

```sh
$ kubectl label node --all storagenode=glusterfs

node "cluster-master" labeled
node "cluster-node1" labeled
node "cluster-node2" labeled
```

## 建立daemon-set glusterfs

會依據`storagenode=glusterfs`去找k8s節點，並在其上建立一個對應的`gluster pod`

```sh
$ kubectl create -f glusterfs-daemonset.yaml --namespace=gluster

daemonset "glusterfs" created
```

## 建立deploy-heketi (用來設定gluster cluster用)

```sh
$ kubectl create -f deploy-heketi-deployment.yaml --namespace=gluster

service "deploy-heketi" created
deployment "deploy-heketi" created
```

## 使用heketi-cl讀取topology.json並開始設定gluster cluster

1. `HEKETI_CLI_SERVER`需抓取`deploy-service ip,port`設定`server url`
2. `heketi-cl`工具才可以連的到`heketi-server`
3. 各節點空磁區要先準備好。
4. `topology.json`要設定好。

```sh
$ export HEKETI_CLI_SERVER=$(kubectl get svc/deploy-heketi --namespace=gluster --template 'http://{{.spec.clusterIP}}:{{(index .spec.ports 0).port}}')
$ echo $HEKETI_CLI_SERVER
http://10.244.2.51:8080
$ heketi-cli topology load --json=topology.json

Creating cluster ... ID: 399ec0094bf3305d0c3438be6cbe3e4b
Creating node cluster-master ... ID: 5fef145bb01325adbc462aae761ef8d4
Adding device /dev/cl/gdb ... OK
Adding device /dev/cl/gdb1 ... OK
Adding device /dev/cl/gdb2 ... OK
Creating node cluster-node1 ... ID: 66cfa4c4462fc14aaaadf24ce33e47f5
Adding device /dev/cl/gdb ... OK
Adding device /dev/cl/gdb1 ... OK
Adding device /dev/cl/gdb2 ... OK
Creating node cluster-node2 ... ID: 7ebd0952cddea76f247d12134687c902
Adding device /dev/cl/gdb ... OK
Adding device /dev/cl/gdb1 ... OK
Adding device /dev/cl/gdb2 ... OK
heketi topology loaded.
```

## 使用heketi-cli建立heketi-storage

會產生`heketi-storage.json`

```sh
$ heketi-cli setup-openshift-heketi-storage

Saving heketi-storage.json
```

## 使用heketi-storage.json建立heketi-storage endpoint及copy job

`heketi-storage-copy-job` 會將`heketi.db`copy到指定位置供後續正式的`heketi-deployment pod`使用。

```sh
$ kubectl create -f heketi-storage.json --namespace=gluster

secret "heketi-storage-secret" created
endpoints "heketi-storage-endpoints" created
service "heketi-storage-endpoints" created
job "heketi-storage-copy-job" created
```

## 刪除heketi deploy相關resource

```sh
$ kubectl delete all,service,jobs,deployment,secret --selector="deploy-heketi" --namespace=gluster

service "deploy-heketi" deleted
job "heketi-storage-copy-job" deleted
deployment "deploy-heketi" deleted
secret "heketi-storage-secret" deleted
```

## 佈署正式heketi server

```sh
$ kubectl create -f heketi-deployment.yaml --namespace=gluster

service "heketi" created
deployment "heketi" created
```

## 測試

這樣安裝就結束了，可以使用`heketi-cli`測試看看

```sh
$ export HEKETI_CLI_SERVER=$(kubectl get svc/heketi --namespace=gluster --template 'http://{{.spec.clusterIP}}:{{(index .spec.ports 0).port}}')

$ echo $HEKETI_CLI_SERVER
http://10.244.2.4:8080

$ curl $HEKETI_CLI_SERVER/hello
Hello from Heketi

$ heketi-cli cluster list
Clusters:
399ec0094bf3305d0c3438be6cbe3e4b

$ heketi-cli node list
Id:5fef145bb01325adbc462aae761ef8d4	Cluster:399ec0094bf3305d0c3438be6cbe3e4b
Id:66cfa4c4462fc14aaaadf24ce33e47f5	Cluster:399ec0094bf3305d0c3438be6cbe3e4b
Id:7ebd0952cddea76f247d12134687c902	Cluster:399ec0094bf3305d0c3438be6cbe3e4b
```