# Declarative approach

## Table of Contents

- [deployment YAML example](#yaml-deployment-example)
- [service YAML example](#yaml-service-example)
- [YAML multiple resources in single file](#yaml-multiple-resources-in-single-file)
- [create or update resource using YAML](#create-or-update-resource-defined-in-yaml)
- [delete resource/s based on YAML](#delete-one-or-more-resources-defined-in-yaml)
- [selectors](#selectors)
  - [matchedLabels](#matchedlabels)
  - [matchedExpressions](#matchexpressions)
  - [delete objects by selector](#delete-objects-by-selector)
- [livenessProbe](#livenessprobe)

## YAML deployment example

[deployment.yaml](./deployment.yaml)

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

[Back to top](#declarative-approach)

## YAML service example

[service.yaml](./service.yaml)

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

[Back to top](#declarative-approach)

## YAML multiple resources in single file

Seperate resource using triple dashes ---

[master-deployment.yaml](./master-deployment.yaml)

<pre>
<b style="color: yellow">apiVersion: v1
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
  type: LoadBalancer</b>
---
<b style="color: red">apiVersion: apps/v1
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
              cpu: "0.5"</b>
</pre>

[Back to top](#declarative-approach)

## Create or Update resource defined in YAML

```
kubectl apply -f=<yaml file>
kubectl apply -f=deployment.yaml
kubectl apply -f=service.yaml
```

[Back to top](#declarative-approach)

## Delete one or more resources defined in YAML

```
kubectl delete -f=<yaml file> -f=<yaml file>
kubectl delete -f=deployment.yaml -f=service.yaml
```

[Back to top](#declarative-approach)

## Selectors

### **matchedLabels**

[deployment.yaml](./deployment.yaml)

<pre>
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-second-app-deployment
  labels:
    group: example
spec:
  replicas: 1
  <b style="font-size: 16px; color: navy">selector:
    matchLabels:
      app: node-second-app-pod
      tier: backend</b>
  template:
    metadata:
      labels:
        app: node-second-app-pod
        tier: backend
    spec:
      containers:
        - name: node-second-app
          image: orennu/kub-declarative-app:0.0.6
          imagePullPolicy: Always
          resources:
            limits:
              memory: 256Mi
              cpu: "0.5"
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
            periodSeconds: 10
            initialDelaySeconds: 5
</pre>

[Back to top](#declarative-approach)

### **matchExpressions**

[deployment.yaml](./deployment.yaml)

<pre>
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-second-app-deployment
  labels:
    group: example
spec:
  replicas: 1
  <b style="font-size: 16px; color: navy">selector:
    matchExpressions:
      - {
          key: app,
          operator: In,
          values: [node-second-app-pod, node-first-app-pod],
        }</b>
  template:
    metadata:
      labels:
        app: node-second-app-pod
        tier: backend
    spec:
      containers:
        - name: node-second-app
          image: orennu/kub-declarative-app:0.0.6
          imagePullPolicy: Always
          resources:
            limits:
              memory: 256Mi
              cpu: "0.5"
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
            periodSeconds: 10
            initialDelaySeconds: 5
</pre>

[Back to top](#declarative-approach)

### Delete objects by selector

```
kubectl delete <object_type_1>,<object_type_2> -l <key>=<value>
kubectl delete deployments,services -l group=example
```

[Back to top](#declarative-approach)

## livenessProbe

[deployment.yaml](./deployment.yaml)

<pre>
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-second-app-deployment
  labels:
    group: example
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
          image: orennu/kub-declarative-app:0.0.6
          imagePullPolicy: Always
          resources:
            limits:
              memory: 256Mi
              cpu: "0.5"
          <b style="font-size: 16px; color: navy">livenessProbe:
            httpGet:
              path: /health
              port: 8080
            periodSeconds: 10
            initialDelaySeconds: 5</b>
</pre>

[Back to top](#declarative-approach)
