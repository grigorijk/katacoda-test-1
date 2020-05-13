### 3.2 Push docker image to Docker Repository

1. #### Login into Docker repository

    Use the command:

    ```sh
    ibmcloud cr login
    ```

    Successful login is marked by response `Login Succeeded`. Now you are authorised to perform operations with docker repository, like pushing the image.

2. #### Push Docker image

    ```sh
    docker push uk.icr.io/lab-cnb/shipping-service-XX
    ```

    After some loading, log should say something like `latest: digest: sha256:89fbdfc4bd21771aa9f18c836c598e631740c8dc33ede7116107ab46fefe1758 size: 3256`

    You can also navigate to the IBM console and view the registry at the following link (ensure you have selected the correct account) https://cloud.ibm.com/kubernetes/registry/main/private
    