[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) is a resource, which allows to access the service not by port, but by the url path on the cluster proxy. It maps the URL to the specific port of the service

1. Create yet another descriptor `ingress.yaml` to define the Ingress:

    <pre class="file hljs yaml"  data-filename="ingress.yaml" data-target="replace">
    apiVersion: extensions/v1beta1
    kind: Ingress
    metadata:
      name: shipping-service-ingress
      namespace: lab-cnb
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

    Service name should match the name from the service descriptor. Make sure that all occurrences of XX are replaced by running the following command:

    ```sh
    cat ingress.yaml | grep X
    ```

    Apply the file with:

    ```sh
    oc apply -f ingress.yaml
    ```

    If the outcome is something like

    ```sh
    ingress.extensions/shipping-service-ingress-XX created
    ```

    we can test it by accessing proxy url with defined path:
    [http://shipping-service-lab-cnb-XX.cnbopenshift-4541c909052590f055286494a1af3e6a-0001.eu-de.containers.appdomain.cloud/shipping?itemId=RRR&type=standard](shipping-service-lab-cnb-XX.cnbopenshift-4541c909052590f055286494a1af3e6a-0001.eu-de.containers.appdomain.cloud/shipping?itemId=RRR&type=standard)

    You may need to accept a security exception in your browser.
    If you see the json response, the same as with service port - your Ingress is working!

    Feel free to use

    ```sh
    oc describe ingress shipping-service-ingress  
    ```

    to see details of ingress