# Kubernetes Volumes - [官網Document](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)

## Kubernetes Glusterfs

A `glusterfs` volume allows a [Glusterfs](http://www.l-penguin.idv.tw/book/Gluster-Storage_GitBook/gluster_intra/gluster_arch.html) (an open source networked filesystem) volume to be mounted into your pod. Unlike `emptyDir`, which is erased when a Pod is removed, the contents of a `glusterfs` volume are preserved and the volume is merely unmounted. This means that a glusterfs volume can be pre-populated with data, and that data can be “handed off” between pods. GlusterFS can be mounted by multiple writers simultaneously.

**Important: You must have your own GlusterFS installation running before you can use it**

See the [GlusterFS example](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/glusterfs) for more details.

## 使用方式

1. 準備網路檔案系統集群([Gluster](http://www.l-penguin.idv.tw/book/Gluster-Storage_GitBook/gluster_intra/gluster_arch.html)/Ceph/Other)
2. 本範例直接用[gluster-kubernetes](https://github.com/gluster/gluster-kubernetes)架一組`gluster cluster`在各個節點上。
3. 建立`Storage Classes`/`Persistent Volumes`。
4. 個別容器設定`pod volumes config`(如`redis/kafka`之類需要保存`data`狀態的容器)。

## 範例

1. 架設gluster-cluster-[install-gluster-kubenetes](install-gluster-kubenetes.md)
2. 建立`Storage Classes`/`Persistent Volumes`並設定容器config[deploy-with-volume](deploy-volume.md)


## 其它

`gluster-kubenetes-master-deploy`保存當前可執行版本 git version `28119b3ed834c1d7bb08810e213dd8e82b02bec2`