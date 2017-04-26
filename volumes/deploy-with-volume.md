# kubernetes gluster volume

## 建立storage class

`resturl`請替換成`heketi-server url`

[storageclass.yaml](storageclass.yaml)
```yaml
apiVersion: storage.k8s.io/v1beta1
kind: StorageClass
metadata:
  name: slow
provisioner: kubernetes.io/glusterfs
parameters:
  resturl: "http://10.111.127.46:8080"
```

```sh
kubectl create -f storageclass.yaml
```

---

## 建立Persistent Volume Claims

1. 以`volume.beta.kubernetes.io/storage-class` 對應
2. `storage` 設定卷大小


[test-pvc.yaml](test-pvc.yaml)
```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: myclaim
  annotations:
    volume.beta.kubernetes.io/storage-class: "slow"
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

```sh
kubectl create -f test-pvc.yaml
```

---

## 掛載範例

待補