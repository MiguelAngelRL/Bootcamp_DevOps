# Exercise 1. Monolith in memory.

Deploy the necessary resources to create an infrastructure like the following picture:

![monolith in memory](./00-monolith-in-mem/monolith-in-mem.png)

For that, the following resources have been deployed in the cluster:

* A LoadBalancer service, by applying the file [monolith_memory_service.yaml](./00-monolith-in-mem/monolith_memory_service.yaml). This service is targeting the pods that have the label _todo-app-pod_, and accept petitions to its 3000 port and redirecting to the 8080 port of the target pods.

* A 2 replicas Deployment using the monolith image _lemoncodersbc/lc-todo-monolith:v5-2024_, by applying the file [monolith_memory_deployment.yaml](./00-monolith-in-mem/monolith_memory_deployment.yaml). The pods will be deployed with the label _todo-app-pod_ and will accept petitions to its 8080 port.

When everything is up and running, we could access to the app from the cluster using both the pod's ip and the loadbalance service:

  ![cluster access](./00-monolith-in-mem/cluster_access.jpg)

To access to the app from our browser, we have to run the _minikube tunnel_ command to reach the loadbalancer service from outside the cluster:

  ![minikube tunnel](./00-monolith-in-mem/minikube_tunnel.jpg)

After doing that, we will be able to access the app from the browser:

  ![browser access](./00-monolith-in-mem/browser_access.jpg)


<br /><br />

# Exercise 2. Monolith and DB.

Deploy the necessary resources to create an infrastructure like the following picture:

![monolith and db](./01-monolith-and-db/monolith-and-db.png)

For that, the following resources have been deployed in the cluster:

* A LoadBalancer service, by applying the file [monolith_service_loadbalancer.yaml](./01-monolith-and-db/monolith_service_loadbalancer.yaml). This service is targeting the pods that have the label _todo-app-pod_, and accept petitions to its 3000 port and redirecting to the 8080 port of the target pods. This service will allow us to access the application from outside the cluster.

* A 1 replica Deployment using the monolith image _lemoncodersbc/lc-todo-monolith-db:v5-2024_, by applying the file [monolith_deployment.yaml](./01-monolith-and-db/monolith_deployment.yaml). The pods will be deployed with the label _todo-app-pod_ and will accept petitions to its 8080 port, as has been defined in the _todo-app-cm_ configmap.

* A ConfigMap to define the environtment variables that will use the application pods, by applying the file [monolith_todo_app_cm.yaml](./01-monolith-and-db/monolith_todo_app_cm.yaml). Here we can find the needed data the application needs to connect to the db server. The db host name will be a service that we will create when defining the statefulset.

* A ClusterIp service, by applying the file [monolith_service_clusterip.yaml](./01-monolith-and-db/monolith_service_clusterip.yaml). This service is targeting the pods that have the label _persistence-pod_, and accept petitions to its 5432 port and redirecting to the 5432 port of the target pods. This service will allow the application to access DB server from the cluster.

