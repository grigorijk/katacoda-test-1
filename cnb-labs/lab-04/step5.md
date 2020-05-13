[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) is a resource, which allows to access the service not by port but by the URL path on the cluster proxy. It maps the URL to the specific port of the service

Katacoda uses its own ingress to route external ports to the internal Kubernetes cluster. Therefore we will create a custom Nginx based proxy that will use ingress definitions to route requests to our application.

1. Deploy ingress definition from prebuilt service descriptor `../nginx-ingress.yaml`{{open}}

  `kubectl apply -f nginx-ingress.yaml`{{execute}}

1. Create yet another descriptor `ingress.yaml` to define the Ingress:

  <pre class="file hljs yaml"  data-filename="ingress.yaml" data-target="replace">
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    name: shipping-service-ingress
    labels:
      app: shipping-service
  spec:
    rules:
    - host: shipping-service-lab-cnb-XX.cnb-barcelona-2020-4541c909052590f055286494a1af3e6a-0001.eu-gb.containers.appdomain.cloud
      http:
        paths:
        - path: /
          backend:
            serviceName: shipping-service-svc
            servicePort: app-port
  </pre>


2. Apply the ingress descriptor with the following command:

  `kubectl apply -f shipping-service-js/ingress.yaml`{{execute}}

    If the outcome is something like

    <pre class="file hljs shell">
    ingress.extensions/shipping-service-ingress created
    </pre>

    we can test it by accessing proxy url with defined path:
  

    You may need to accept a security exception in your browser.
    If you see the json response, the same as with service port - your Ingress is working!

    Feel free to use

    ```sh
    kubectl describe ingress shipping-service-ingress  
    ```

    to see details of ingress