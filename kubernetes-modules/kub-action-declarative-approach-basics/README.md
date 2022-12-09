# Declarative approach

## Table of Contents

- [deployment YAML example](#yaml-deployment-example)
- [service YAML example](#yaml-service-example)
- [create or update resource using YAML](#create-or-update-resource-defined-in-yaml)
- [delete resource/s based on YAML](#delete-one-or-more-resources-defined-in-yaml)
- [selectors](#selectors)
  - [matchedLabels](#matchedlabels)
  - [matchedExpressions](#matchexpressions)
  - [delete objects by selector](#delete-objects-by-selector)

## YAML deployment example

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-second-app-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: node-second-app-pod
      tier: backend
  template:
    metadata:
      labels:
        app: node-second-app-pod
        tier: backend
    spec:
      containers:
        - name: node-second-app
          image: orennu/kub-declarative-app:0.0.3
          resources:
            limits:
              memory: 256Mi
              cpu: "0.5"
```

## YAML service example

```
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: node-second-app-pod
  ports:
    - protocol: "TCP"
      port: 80
      targetPort: 8080
  type: LoadBalancer
```

## Create or Update resource defined in YAML

```
kubectl apply -f=<yaml file>
kubectl apply -f=deployment.yaml
kubectl apply -f=service.yaml
```

## Delete one or more resources defined in YAML

```
kubectl delete -f=<yaml file> -f=<yaml file>
kubectl delete -f=deployment.yaml -f=service.yaml
```

## Selectors

### **matchedLabels**

```
selector:
    matchLabels:
      app: node-second-app-pod
      tier: backend
```

### **matchExpressions**

```
selector:
    matchExpressions:
      - {
          key: app,
          operator: In,
          values: [node-second-app-pod, node-first-app-pod],
        }
```

### Delete objects by selector

```
kubectl delete <object_type_1>,<object_type_2> -l <key>=<value>
kubectl delete deployments,services -l group=example
```

## livenessProbe

```
containers:
    - name: node-second-app
      image: orennu/kub-declarative-app:0.0.3
      livenessProbe:
      httpGet:
        path: /
        port: 8080
      periodSeconds: 10
      initialDelaySeconds: 5
```
