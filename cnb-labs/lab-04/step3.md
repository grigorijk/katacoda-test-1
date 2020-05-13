One of the main artefacts in Kubernetes is "Deployment". It is linked with docker image and it is responsible for defining the pods and their properties. In other words: deployment can be called "kubernetes application".

1. To create a deployment, we need to create a YAML file, that describes it. In the project directory, create file, named `deployment.yaml`:

    <pre class="file hljs yaml"  data-filename="deployment.yaml" data-target="replace">
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: shipping-service
      name: shipping-service
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            app: shipping-service
        spec:
          containers:
          - image: localhost:5000/lab-cnb/shipping-service
            name: shipping-service
            ports:
            - name: app-port
              containerPort: 3001
    </pre>

    Important part here is the `image` part that refers to the unique docker image name in our local registry which was built, run and pushed earlier. `containerPort` for should be `3001`

1. Apply this configuration using following command:

    `kubectl apply -f shipping-service/deployment.yaml`{{execute}}

    The output should be similar to

    <pre class="file hljs shell">
    deployment.extensions/shipping-service created
    </pre>

1. Try some `kubectl` commands to check newly created deployment:

    `kubectl get deployments`{{execute}}

    `kubectl describe deployment shipping-service`{{execute}}

    First command will list all deployments in the lab namespace. With `describe` command you can get details of the deployment (or other resources by name)