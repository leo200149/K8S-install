kubectl create -f zk-service.yaml
echo 'wait zk-service deploy...'
sleep 10s
kubectl create -f zk-cluster.yaml
echo 'wait zk-cluster deploy...'
sleep 30s
kubectl create -f kafka-service.yaml
echo 'wait kafka-service deploy...'
sleep 10s
kubectl create -f kafka-cluster.yaml
echo 'wait kafka-cluster deploy...'
sleep 30s
kubectl create -f kafka-cluster-slave.yaml
echo 'wait kafka-cluster-slave deploy...'
sleep 30s
echo 'deploy finish'
