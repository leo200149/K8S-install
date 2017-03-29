kubectl create -f zk-service.yaml
sleep 10s
kubectl create -f zk-cluster.yaml
sleep 60s
kubectl create -f kafka-service.yaml
sleep 10s
kubectl create -f kafka-cluster.yaml
sleep 30s
kubectl create -f kafka-cluster-slave.yaml
