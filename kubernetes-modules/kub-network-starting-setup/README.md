# Kubernetes networking

## Table of Contents

- [Kubernetes service types](#kubernetes-service-types)
  - [Loadbalancer](#uloadbalanceru)
  - [ClusterIP](#uclusteripu)
- [Using environment variables for service address](#uusing-environment-variables-for-service-addressu)
  - [kubernetes dnsCore service address](#ukubernetes-dnscore-service-addressu)
  - [kubernetes dynamic service address](#ukubernetes-service-domain-nameu)
  - [localhost address](#ulocalhost-addressu)
- [Understanding Cross-Site Resource Sharing (CORS)](https://academind.com/tutorials/cross-site-resource-sharing-cors)
- [Using kubernetes dynamic service address](#using-kubernetes-service-domain-name)

### Kubernetes service types

#### <u>**LoadBalancer**</u>

Will expose service port to the public.  
To be used with public facing services.

Example:  
[tasks-service.yaml](./kubernetes/tasks-service.yaml)

<pre>
apiVersion: v1
kind: Service
metadata:
  name: tasks-service
spec:
  selector:
    app: tasks
  <b style="font-size: 16px; color: navy;">type: LoadBalancer
  ports:
    - protocol: "TCP"
      port: 8000
      targetPort: 8000</b>

</pre>

[Back to top](#kubernetes-networking)

#### <u>**ClusterIP**</u>

Will expose service port only within the cluster.  
To be used for backend2backend service comuunication.

Example:  
[auth-service.yaml](./kubernetes/auth-service.yaml)

<pre>
apiVersion: v1
kind: Service
metadata:
  name: auth-service
spec:
  selector:
    app: auth
  <b style="font-size: 16px; color: navy;">type: ClusterIP
  ports:
    - protocol: "TCP"
      port: 80
      targetPort: 80</b>
</pre>

[Back to top](#kubernetes-networking)

### Using environment variables for service address

In order to communicate with service address there are 3 options:

#### <u>**kubernetes dnsCore service address**</u>

Use kubernetes dnsCore service address (i.e. service\*name.namespace), for example, if service name is **\*tasks-service**_ and namespace is _**default**_, use _**tasks-service.default**\_ and declare it in the deployment file.

   <pre>
   apiVersion: apps/v1
   kind: Deployment
   metadata:
   name: users-deployment
   spec:
   replicas: 1
   selector:
       matchLabels:
       app: users
   template:
       metadata:
       labels:
           app: users
       spec:
       containers:
           - name: users
           image: orennu/kub-net-users-demo:latest
           <b style="font-size: 16px; color: navy;">env:
               - name: AUTH_ADDRESS
               value: "auth-service.default"</b>
           resources:
               limits:
               cpu: "0.25"
               memory: 256Mi
   </pre>

then in your code use the environment variable  
 [users-app.js](./users-api/users-app.js)

<pre>
const hashedPW = await axios.get(
`http://<b style="font-size: 16px; color: navy;">${process.env.AUTH_ADDRESS}</b>/hashed-password/${password}`
);
</pre>

this way, you can also use the same environment variable in your _**docker-compose.yaml**_ when deploying locally.

<pre>
services:
  auth:
    build: ./auth-api
  users:
    build: ./users-api
    <b style="font-size: 16px; color: navy;">environment:
      AUTH_ADDRESS: auth</b>
       AUTH_SERVICE_SERVICE_HOST: auth
    ports:
      - "8080:8080"
  tasks:
    build: ./tasks-api
    ports:
      - "8000:8000"
    environment:
      TASKS_FOLDER: tasks
      AUTH_ADDRESS: auth
</pre>

[Back to top](#kubernetes-networking)

#### <u>**kubernetes service domain name**</u>

Use kubernetes service domain name (i.e. SERVICE_NAME_SERVICE_HOST), note that SERVICE_NAME is the service name in uppercase and dashes should be replaced with underscores.

<pre>
const hashedPW = await axios.get(
`http://<b style="font-size: 16px; color: navy;">${process.env.AUTH_SERVICE_SERVICE_HOST}</b>/hashed-password/${password}`
);
</pre>

Note that you cannot use kubernetes service domain name for local deployment using docker-compose.yaml.

[Back to top](#kubernetes-networking)

#### <u>**localhost address**</u>

For communication between containers in the <u>**same**</u> pod only, you can use **localhost** as the service address.

<pre>
apiVersion: apps/v1
kind: Deployment
metadata:
name: users-deployment
spec:
replicas: 1
selector:
    matchLabels:
    app: users
template:
    metadata:
    labels:
        app: users
    spec:
    containers:
        - name: users
        image: orennu/kub-net-users-demo:latest
        <b style="font-size: 16px; color: navy;">env:
            - name: AUTH_ADDRESS
              value: localhost</b>
        resources:
            limits:
            cpu: "0.25"
            memory: 256Mi
</pre>

Also cannot be used for local deployment with docker-compose.yaml.

[Back to top](#kubernetes-networking)

### Using kubernetes service domain name

To avoid hardcoding services addresses in your code, you can use kubernetes service domain name when communication is inside the same cluster.

[nginx.conf](./frontend/conf/nginx.conf)

<pre>
server {
  listen 80;

  <b style="font-size: 16px; color: navy;">location /api/ {
    proxy_pass http://tasks-service.default:8000/;
  }</b>
  
  location / {
    root /usr/share/nginx/html;
    index index.html index.htm;
    try_files $uri $uri/ /index.html =404;
  }
  
  include /etc/nginx/extra-conf.d/*.conf;
}
</pre>

[Back to top](#kubernetes-networking)
