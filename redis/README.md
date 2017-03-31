# Redis 佈署

## 資源

k8s github:[kubernetes/tree/master/examples](https://github.com/kubernetes/kubernetes/tree/master/examples)

---

## 佈署步驟

可一步一步做或使用[deployRedis.sh](deployRedis.sh) 完成佈署

### 建立redis master service:[redis-master-service.yaml](redis-master-service.yaml)

```sh
kubectl create -f redis-master-service.yaml
```

---

### 佈署redis master:[redis-master-deployment.yaml](redis-master-deployment.yaml)

```sh
kubectl create -f redis-master-deployment.yaml
```

---

### 建立redis slave service:[redis-slave-service.yaml](redis-slave-service.yaml)

```sh
kubectl create -f redis-slave-service.yaml
```

---

#### 佈署redis slave:[redis-slave-deployment.yaml](redis-slave-deployment.yaml)

```sh
kubectl create -f redis-slave-deployment.yaml
```

---

### 使用redis

host: `{master-ip}:30379`

---
