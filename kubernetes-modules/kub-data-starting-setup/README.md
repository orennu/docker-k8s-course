# Kubernetes data

## Table of Contents

- [Restart a pod](#restrat-a-pod)
- [Deployment using emptyDir volume](#deployment-using-emptydir-volume---bound-to-specific-pod)
- [Deployment using hostPath volume](#deployment-using-hostpath-volume---bound-to-specific-node)
- [Persistent Volume declaration (hostPath)](#persistent-volume-declaration---hostpath)
- [Persistent Volume Claim declaration](#persistent-volume-claim-declaration)
- [Deployment with Persistent Volume Claim](#deployment-with-persistent-volume-claim)
- [Get Persistent Volumes](#get-persistent-volumes)
- [Get Persistent Volumes Claims](#get-persistent-volumes-claims)
- [Setting environment variables in deployment](#setting-environment-variables-in-deployment)
- [ConfigMap declaration](#configmap-declaration)
- [Get ConfigMaps](#get-configmaps)
- [Using ConfigMap in deployment](#using-configmap-in-deployment)

### Restrat a pod

```
kubectl rollout restart deployment <deployment name>
kubectl rollout restart deployment story-deployment
```

[Back to top](#kubernetes-data)

### Deployment using emptyDir volume - bound to specific pod

[deployment.yaml](./deployment.yaml)

<pre>
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
  labels:
    group: data-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: story-app
  template:
    metadata:
      labels:
        app: story-app
    spec:
      containers:
        - name: story-container
          image: orennu/kub-data-demo:latest
          <b style="font-size: 16px; color: navy">volumeMounts:
            - mountPath: /app/story
              name: story-volume</b>
          resources:
            limits:
              memory: 256Mi
              cpu: "0.25"
      <b style="font-size: 16px; color: navy;">volumes:
        - name: story-volume
          emptyDir: {}</b>
</pre>

[Back to top](#kubernetes-data)

### Deployment using hostPath volume - bound to specific node

[deployment.yaml](./deployment.yaml)

<pre>
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
  labels:
    group: data-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: story-app
  template:
    metadata:
      labels:
        app: story-app
    spec:
      containers:
        - name: story-container
          image: orennu/kub-data-demo:latest
          <b style="font-size: 16px; color: navy">volumeMounts:
            - mountPath: /app/story
              name: story-volume</b>
          resources:
            limits:
              memory: 256Mi
              cpu: "0.25"
      <b style="font-size: 16px; color: navy">volumes:
        - name: story-volume
          hostPath:
            path: /data
            type: DirectoryOrCreate</b>
</pre>

[Back to top](#kubernetes-data)

### Persistent Volume declaration - hostPath

[host-pv.yaml](./host-pv.yaml)

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: host-pv
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  storageClassName: standard
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /data
    type: DirectoryOrCreate
```

[Back to top](#kubernetes-data)

### Persistent Volume Claim declaration

[host-pvc.yaml](./host-pvc.yaml)

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: host-pvc
spec:
  volumeName: host-pv
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 1Gi
```

[Back to top](#kubernetes-data)

### Deployment with Persistent Volume Claim

[deployment.yaml](./deployment.yaml)

<pre>
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
  labels:
    group: data-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: story-app
  template:
    metadata:
      labels:
        app: story-app
    spec:
      containers:
        - name: story-container
          image: orennu/kub-data-demo:latest
          <b style="font-size: 16px; color: navy">volumeMounts:
            - mountPath: /app/story
              name: story-volume</b>
          resources:
            limits:
              memory: 256Mi
              cpu: "0.25"
      <b style="font-size: 16px; color: navy">volumes:
        - name: story-volume
          persistentVolumeClaim:
            claimName: host-pvc</b>
</pre>

[Back to top](#kubernetes-data)

### Get Persistent Volumes

```
kubectl get pv
```

[Back to top](#kubernetes-data)

### Get Persistent Volumes Claims

```
kubectl get pvc
```

[Back to top](#kubernetes-data)

### Setting environment variables in deployment

[deployment.yaml](./deployment.yaml)

<pre>
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
  labels:
    group: data-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: story-app
  template:
    metadata:
      labels:
        app: story-app
    spec:
      containers:
        - name: story-container
          image: orennu/kub-data-demo:latest
          <b style="font-size: 16px; color: navy">env:
            - name: STORY_FOLDER
              value: "story"</b>
          volumeMounts:
            - mountPath: /app/story
              name: story-volume
          resources:
            limits:
              memory: 256Mi
              cpu: "0.25"
      volumes:
        - name: story-volume
          persistentVolumeClaim:
            claimName: host-pvc
</pre>

[Back to top](#kubernetes-data)

### ConfigMap declaration

[environment.yaml](./environment.yaml)

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: data-store-env
data:
  # key: value
  folder: "story"
```

[Back to top](#kubernetes-data)

### Get ConfigMaps

```
kubectl get configmaps
```

[Back to top](#kubernetes-data)

### Using ConfigMap in deployment

[deployment.yaml](./deployment.yaml)

<pre>
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
  labels:
    group: data-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: story-app
  template:
    metadata:
      labels:
        app: story-app
    spec:
      containers:
        - name: story-container
          image: orennu/kub-data-demo:latest
          <b style="font-size: 16px; color: navy">env:
            - name: STORY_FOLDER
              valueFrom:
                configMapKeyRef:
                  name: data-store-env
                  key: folder</b>
          volumeMounts:
            - mountPath: /app/story
              name: story-volume
          resources:
            limits:
              memory: 256Mi
              cpu: "0.25"
      volumes:
        - name: story-volume
          persistentVolumeClaim:
            claimName: host-pvc
</pre>

[Back to top](#kubernetes-data)
