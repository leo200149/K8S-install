# Volumes


## Glusterfs

A `glusterfs` volume allows a [Glusterfs](http://www.l-penguin.idv.tw/book/Gluster-Storage_GitBook/gluster_intra/gluster_arch.html) (an open source networked filesystem) volume to be mounted into your pod. Unlike `emptyDir`, which is erased when a Pod is removed, the contents of a `glusterfs` volume are preserved and the volume is merely unmounted. This means that a glusterfs volume can be pre-populated with data, and that data can be “handed off” between pods. GlusterFS can be mounted by multiple writers simultaneously.

**Important: You must have your own GlusterFS installation running before you can use it**

See the [GlusterFS example](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/glusterfs) for more details.

---

## Cephfs

A `cephfs` volume allows an existing [CephFS](http://docs.ceph.com/docs/master/cephfs/) volume to be mounted into your pod. Unlike `emptyDir`, which is erased when a Pod is removed, the contents of a `cephfs` volume are preserved and the volume is merely unmounted. This means that a CephFS volume can be pre-populated with data, and that data can be “handed off” between pods. CephFS can be mounted by multiple writers simultaneously.

**Important: You must have your own Ceph server running with the share exported before you can use it**

See the [CephFS example](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/cephfs/) for more details.

---

## Nfs

An `nfs` volume allows an existing [NFS](http://linux.vbird.org/linux_server/0330nfs.php) (Network File System) share to be mounted into your pod. Unlike `emptyDir`, which is erased when a Pod is removed, the contents of an `nfs` volume are preserved and the volume is merely unmounted. This means that an NFS volume can be pre-populated with data, and that data can be “handed off” between pods. NFS can be mounted by multiple writers simultaneously.

**Important: You must have your own NFS server running with the share exported before you can use it**

See the [NFS example](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/nfs) for more details.

---

## Rbd

An `rbd` volume allows a [Rados Block Device](http://ceph.com/docs/master/rbd/rbd/) volume to be mounted into your pod. Unlike `emptyDir`, which is erased when a Pod is removed, the contents of a `rbd` volume are preserved and the volume is merely unmounted. This means that a RBD volume can be pre-populated with data, and that data can be “handed off” between pods.

**Important: You must have your own Ceph installation running before you can use RBD**

A feature of RBD is that it can be mounted as read-only by multiple consumers simultaneously. This means that you can pre-populate a volume with your dataset and then serve it in parallel from as many pods as you need. Unfortunately, RBD volumes can only be mounted by a single consumer in read-write mode - no simultaneous writers allowed.

See the [RBD example](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/rbd) for more details.


---