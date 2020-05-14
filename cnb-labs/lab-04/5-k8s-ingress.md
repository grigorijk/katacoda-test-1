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
    - host: [[HOST_SUBDOMAIN]]-30001-[[KATACODA_HOST]].environments.katacoda.com
      http:
        paths:
        - path: /ingress-shipping
          backend:
            serviceName: shipping-service
            servicePort: app-port
  </pre>

1. Apply the ingress descriptor with the following command:

  `kubectl apply -f shipping-service/ingress.yaml`{{execute}}

    If the outcome is something like

    <pre class="file hljs shell">
    ingress.extensions/shipping-service-ingress created
    </pre>

1. Ingress path can be tested by accessing proxy url with defined path:

    https://[[HOST_SUBDOMAIN]]-30001-[[KATACODA_HOST]].environments.katacoda.com/ingress-shipping?itemId=CCC&type=regular
  
  Note, that changing context path to anything other than `ingress-shipping` stops routing requests to the shipping service. This proves that requests are routed via Nginx load balances in contrast to Kubernetes service from the previous step  

1. Check details of ingress with the following command:

  `kubectl describe ingress shipping-service-ingress`{{execute}}
