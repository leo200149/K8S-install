kubectl create -f redis-master-service.yaml
echo 'wait redis-master-service deploy...'
sleep 10s
kubectl create -f redis-master-deployment.yaml
echo 'wait redis-master-deployment deploy...'
sleep 30s
kubectl create -f redis-slave-service.yaml
echo 'wait redis-slave-service deploy...'
sleep 10s
kubectl create -f redis-slave-deployment.yaml
echo 'wait redis-slave-deployment deploy...'
sleep 30s
echo 'deploy finish'
