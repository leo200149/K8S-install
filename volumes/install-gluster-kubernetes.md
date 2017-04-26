# GlusterFS + heketi on Kubernetes install

## 參考

1. [gluster-kubernetes](https://github.com/gluster/gluster-kubernetes)
2. [heketi](https://github.com/heketi/heketi)
3. [踩雷參考](http://blog.lwolf.org/post/how-i-deployed-glusterfs-cluster-to-kubernetes/)

---

## 安裝前置作業

### master-node要裝 `heketi-client`

```sh
wget https://github.com/heketi/heketi/releases/download/v4.0.0/heketi-client-v4.0.0.linux.amd64.tar.gz
tar xzvf heketi-1.0.1.linux.amd64.tar.gz
cp heketi-client/bin/heketi-cli /usr/bin/heketi-cli
heketi-cl --help
```

### 每台node要裝 `gluster-client`

```sh
yum install glusterfs-client
```

### 每台node要設SELinux權限(如果SELinux整個關掉就沒差了)

```sh
setsebool -P virt_sandbox_use_fusefs on
```

### 每台node準備空磁區供 `gluster-cluster` 使用

`centos7 xfs`切磁區的方式可參考[調整XFS格式的LogicalVolume大小](http://jamyy.us.to/blog/2015/09/7673.html)

切磁區請小心操作。

本範例在每台node上各準備了3個空磁區
1. `/dev/cl/gdb`
2. `/dev/cl/gdb1`
3. `/dev/cl/gdb2`


## 開始安裝

---

### 先clone gluster-kubernetes 下來

```sh
git clone https://github.com/gluster/gluster-kubernetes
```

### 設定heketi topology.json

```sh
cd gluster-kubernetes/deploy
cp topology.json.sample topology.json
vi topology.json
```

```json
{
  "clusters": [
    {
      "nodes": [
        {
          "node": {
            "hostnames": {
              "manage": [
                "cluster-master" #kubernetes主節點hostname
              ],
              "storage": [
                "192.168.100.136" #kubernetes主節點ip
              ]
            },
            "zone": 1
          },
          "devices": [
            "/dev/cl/gdb", #準備的空磁區放幾個都可以（可以不用格式化）
            "/dev/cl/gdb1",
            "/dev/cl/gdb2"
          ]
        },
        {
          "node": {
            "hostnames": {
              "manage": [
                "cluster-node1" #kubernetes節點hostname
              ],
              "storage": [
                "192.168.100.132" #kubernetes節點ip
              ]
            },
            "zone": 1
          },
          "devices": [
            "/dev/cl/gdb", #準備的空磁區放幾個都可以（可以不用格式化）
            "/dev/cl/gdb1",
            "/dev/cl/gdb2"
          ]
        },
        {
          "node": {
            "hostnames": {
              "manage": [
                "cluster-node2" #kubernetes節點hostname
              ],
              "storage": [
                "192.168.100.133" #kubernetes節點ip
              ]
            },
            "zone": 1
          },
          "devices": [
            "/dev/cl/gdb", #準備的空磁區放幾個都可以（可以不用格式化）
            "/dev/cl/gdb1",
            "/dev/cl/gdb2"
          ]
        }
      ]
    }
  ]
}
```

### 開始deploy

1. 建立`namespace gluster`
2. 執行`gk-deploy`腳本 [腳本執行步驟拆分說明](gk-deploy-detail.md)
3. `-g` 建立`daemonset-glusterfs` `-n` 設定`namespace` `-c` 環境是`k8s`

```sh
$ kubectl create namespace gluster
$ ./gk-deploy -g -n gluster -c kubectl

Welcome to the deployment tool for GlusterFS on Kubernetes and OpenShift.
Before getting started, this script has some requirements of the execution
environment and of the container platform that you should verify.
The client machine that will run this script must have:
 * Administrative access to an existing Kubernetes or OpenShift cluster
 * Access to a python interpreter 'python'
 * Access to the heketi client 'heketi-cli'
Each of the nodes that will host GlusterFS must also have appropriate firewall
rules for the required GlusterFS ports:
 * 2222  - sshd (if running GlusterFS in a pod)
 * 24007 - GlusterFS Daemon
 * 24008 - GlusterFS Management
 * 49152 to 49251 - Each brick for every volume on the host requires its own
   port. For every new brick, one new port will be used starting at 49152. We
   recommend a default range of 49152-49251 on each host, though you can adjust
   this to fit your needs.
In addition, for an OpenShift deployment you must:
 * Have 'cluster_admin' role on the administrative account doing the deployment
 * Add the 'default' and 'router' Service Accounts to the 'privileged' SCC
 * Have a router deployed that is configured to allow apps to access services
   running in the cluster
Do you wish to proceed with deployment?

[Y]es, [N]o? [Default: Y]: Y
```

### 如果一切都順利的話可以看到

```
Using Kubernetes CLI.
NAME      STATUS    AGE
gluster   Active    3m
Using namespace "gluster".
Checking that heketi pod is not running ... OK
serviceaccount "heketi-service-account" created
clusterrolebinding "heketi-sa-view" created
node "cluster-master" labeled
node "cluster-node1" labeled
node "cluster-node2" labeled
daemonset "glusterfs" created
Waiting for GlusterFS pods to start ... OK
service "deploy-heketi" created
deployment "deploy-heketi" created
Waiting for deploy-heketi pod to start ... OK
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
Saving heketi-storage.json
secret "heketi-storage-secret" created
endpoints "heketi-storage-endpoints" created
service "heketi-storage-endpoints" created
job "heketi-storage-copy-job" created
service "deploy-heketi" deleted
job "heketi-storage-copy-job" deleted
deployment "deploy-heketi" deleted
secret "heketi-storage-secret" deleted
service "heketi" created
deployment "heketi" created
Waiting for heketi pod to start ... OK
heketi is now running and accessible via http://10.244.2.4:8080/
Ready to create and provide GlusterFS volumes.
```

### 這樣安裝就結束了，可以使用`heketi-cli`測試看看

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