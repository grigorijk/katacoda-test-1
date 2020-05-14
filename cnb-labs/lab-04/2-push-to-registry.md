Our application's Docker image is currently available in our local machine only. To make it available for deployment outside of our environment it should be pushed to a Docker registry that acts as shared repository to get Docker images. 

There are public and private Docker registries. The most known public registry is [Docker Hub](https://hub.docker.com). Private registries are used to keep Docker images with a limited access scope. Typically managed Kubernetes clusters has a private Docker registry with strict access control enabled.

We use simplified Katacoda environment without a Docker registry, so let's install a simple one that is not secured and can not be accessed from outside

1. Run the following docker command to run Docker registry container:

    `docker run -d -p 5000:5000 --restart always --name registry registry:2`{{execute}}

1. Let's tag our application Docker image, so it is associated with the new registry:

   `docker tag lab-cnb/shipping-service localhost:5000/lab-cnb/shipping-service`{{execute}}

1. Now we can push the Docker image to the registry

    `docker push localhost:5000/lab-cnb/shipping-service`{{execute}}

    After some loading, log should say something like `latest: digest: sha256:89fbdfc4bd21771aa9f18c836c598e631740c8dc33ede7116107ab46fefe1758 size: 3256`
