# Kafka 佈署

## 資源

1. zookeeper image:[digitalwonderland/zookeeper/](https://hub.docker.com/r/digitalwonderland/zookeeper/)
2. kafka image:[wurstmeister/kafka](https://hub.docker.com/r/wurstmeister/kafka)

---

## 佈署步驟

可一步一步做或使用[deployZookeeperAndKafka.sh](deployZookeeperAndKafka.sh) 完成佈署

### 建立zookeeper service:[zk-service.yaml](zk-service.yaml)

```sh
kubectl create -f zk-service.yaml
```

---

### 佈署zookeeper:[zk-cluster.yaml](zk-cluster.yaml)

```sh
kubectl create -f zk-cluster.yaml
```

---

### 建立kafka service:[kafka-service.yaml](kafka-service.yaml)

```sh
kubectl create -f kafka-service.yaml
```

---

### 佈署kafka master:[kafka-cluster.yaml](kafka-cluster.yaml)

```sh
kubectl create -f kafka-cluster.yaml
```

---

### 佈署kafka slave:[kafka-cluster.yaml](kafka-cluster-slave.yaml)

```sh
kubectl create -f kafka-cluster-slave.yaml
```

---

### 使用kafka

host: `{master-ip}:30092`

---