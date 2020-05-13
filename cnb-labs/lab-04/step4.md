Deployments are running inside kubernetes internal network and are not reachable outside of it. In order to expose the application to the outside world (at least in cluster scope) you need to create kubernetes [Service](https://kubernetes.io/docs/concepts/services-networking/service/). Services also load-balance the load to the existing set of pods when a deployment has more than one of them.

1. To create Kubernetes service we need to provide service descriptor. Create file, named `service.yaml` with the following contents:

    <pre class="file hljs yaml"  data-filename="deployment.yaml" data-target="replace">
    apiVersion: v1
    kind: Service
    metadata:
    name: shipping-service
    labels:
        app: shipping-service
    spec:
    type: NodePort
    ports:
        - name: app-port
        targetPort: app-port
        nodePort: 30000
        port: 3000
    selector:
        app: shipping-service
    </pre>

1. Apply `service.yaml`{{open}} using the same `kubectl apply` command:

    `kubectl apply -f service.yaml`{{execute}}

    This service takes container port `3001` and exposes it as a generated node port `3000` (hence the `type: NodePort`). This way app becomes reachable outside of kubernetes internal cluster network.

1. Find the service and test it directly

    `kubectl describe service shipping-service`{{execute}}

    This command prints out the details of the service. It also contains the line like this:

    ```sh
    NodePort:                 <unset>  30000/TCP
    ```

    this is our assigned NodePort(`30000`), which is used to listen for requests from the outside. Of course, the exact port number will be different for each service

1. Check the service using node port by navigating to the following URL: https://[[HOST_SUBDOMAIN]]-30000-[[KATACODA_HOST]].environments.katacoda.com/shipping?itemId=AAA&type=regular