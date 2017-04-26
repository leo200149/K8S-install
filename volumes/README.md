# Kubernetes Volumes - [官網Document](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)

## 使用方式

1. 準備網路檔案系統集群([Gluster](http://www.l-penguin.idv.tw/book/Gluster-Storage_GitBook/gluster_intra/gluster_arch.html)/Ceph/Other)
2. 本範例直接用[gluster-kubernetes](https://github.com/gluster/gluster-kubernetes)架一組`gluster cluster`在各個節點上。
3. 建立`Storage Classes`/`Persistent Volumes`。
4. 個別容器設定`pod volumes config`(如`redis/kafka`之類需要保存`data`狀態的容器)。

---

## 範例

1. 架設gluster-cluster-[install-gluster-kubernetes](install-gluster-kubernetes.md)
2. 建立`Storage Classes`/`Persistent Volumes`並設定容器config[deploy-with-volume](deploy-with-volume.md)

---

## 其它

1. `gluster-kubenetes-master-deploy`保存當前可執行版本 git version `28119b3ed834c1d7bb08810e213dd8e82b02bec2`
2. [GlusterFS example](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/glusterfs) for more details.