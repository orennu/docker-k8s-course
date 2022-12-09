# commands

## Start the minikube cluster

```
minikube start
```

## Get minikube cluster status

```
minikube status
```

## Launch kubernetes dashboard within minikube cluster

```
minikube dashboard
```

## Create a deployment

```
kubectl create deployment <deployment name> --image=<image name>
kubectl create deployment node-first-app --image=orennu/kub-first-app
```

## Get deployments

```
kubectl get deployments
```

## Get pods

```
kubectl get pods
```

## Delete a deployment

```
kubectl delete deployment <deployment name>
kubectl delete deployment node-first-app
```

## Expose deployment through service

```
kubectl expose deployment <deployment name> --type=<service type> --port=<port>
kubectl expose deployment node-first-app --type=LoadBalancer --port=8080
```

## Get services

```
kubectl get services
```

## Return url to connect to a service in minikube cluster

```
minikube service <service name>
minikube service node-first-app
```

## Scale a deployment

```
kubectl scale deployment/<deployment name> --replicas=<number of replicas>
kubectl scale deployment/node-first-app --replicas=3
```

## Update deployment image

```
kubectl set image deployment/<deployment name> <container name>=<image name>
kubectl set image deployment/node-first-app kub-first-app=orennu/kub-first-app:2
```

## Get deployment rollout status

```
kubectl rollout status deployment/<deployment name>
kubectl rollout status deployment/node-first-app
```

## Rollback a deployment to previous one

```
kubectl rollout undo deployment/<deployment name>
kubectl rollout undo deployment/node-first-app
```

## Get deployment rollout history

```
kubectl rollout history deployment/<deployment name>
kubectl rollout history deployment/node-first-app
```

## Get deployment rollout revision details

```
kubectl rollout history deployment/<deployment name> --revision=<revision number>
kubectl rollout history deployment/node-first-app --revision=4
```

## Rollback a deployment to specific revision

```
kubectl rollout undo deployment/<deployment name> --to-revision=<revision number>
kubectl rollout undo deployment/node-first-app --to-revision=4
```

## Delete a service

```
kubectl delete service <service name>
kubectl delete service node-first-app
```
