# K8S Docker app deploy

所有操作都在k8s-master上完成，k8s-master會自動將pod分配佈署至k8s-node。

## 安裝私有docker image庫(如有現成的可不裝)

### dp.yaml
```yaml
 kind:       Deployment
 apiVersion: extensions/v1beta1
 metadata:
   name: registry
   labels:
     app: registry
 spec:
   replicas: 1
   template:
     metadata:
       labels:
         app: registry
     spec:
       containers:
         - name:  registry
           image: docker.io/registry:2
           ports:
             - containerPort: 5000
               name:          client
```

### svc.yaml

```yaml
 kind:       Service
 apiVersion: v1
 metadata:
   name: registry
   labels:
     app: registry
 spec:
   type: LoadBalancer
   selector:
     app: registry
   ports:
     - name:       client
       port:       5000
       targetPort: client
 status:
   loadBalancer:
     ingress:
       - ip: 0.0.0.0
```

### 執行佈署
```sh
kubectl create -f dp.yaml -f svc.yaml
```

### 檢查是否佈署成功

```sh
kubectl describe svc registry | grep NodePort
```

---

## build app image

```sh
docker build -f Dockerfile -t 127.0.0.1:{port}/{imageName}:{version} .
```

## push image至私有庫

```sh
docker push 127.0.0.1:{port}/{imageName}
```

## K8S deploy app

```sh
kubectl run {deployName} --image=127.0.0.1:{port}/{imageName}:{version}
```

## K8S service pod port 綁定

```sh
kubectl expose deployment/{deployName} --type="NodePort" --port {appPort} --nodePort {nodePort}
```

使用`{master-ip}:{nodePort}`即可接至該container

## K8S 自動佈署三個pod

```sh
kubectl scale deployments/{deployName} --replicas=3
```