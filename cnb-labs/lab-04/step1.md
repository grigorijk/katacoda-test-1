Docker container is created from the application build outcome, using `Dockerfile` as image definition

1. Create `Dockerfile` as per following definition:

    <pre class="file hljs docker"  data-filename="Dockerfile" data-target="replace">
    FROM node:12

    # Create app directory
    WORKDIR /usr/src/app/src

    # Install app dependencies
    # A wildcard is used to ensure both package.json AND package-lock.json are copied
    # where available (npm@5+)
    COPY package*.json ./

    RUN npm install
    # If you are building your code for production
    # RUN npm install --only=production
    ENV PRODUCT_SERVICE_URL=v7a4m6m4.hostrycdn.com/product-service/products
    # Bundle app source
    RUN mkdir src
    COPY src src

    EXPOSE 3001
    CMD [ "npm", "start" ]
    </pre>

    Have a look at [https://docs.docker.com/engine/reference/builder/](https://docs.docker.com/engine/reference/builder/) and take a few minutes to understand the options used in our Dockerfile.

2. Build the image using created file:

    `docker build -t lab-cnb/shipping-service-js shipping-service-js/.`{{execute}}

    Note the dot at the end, it tells where to look for `Dockerfile` (current directory)

3. Test docker image locally

    We can run the created docker image by using `docker run`:

    `docker run --name shipping-service-js -t --rm -p 3001:3001 lab-cnb/shipping-service-js`{{execute}}

   Return to the shell with `Ctrl+C`. The container is continuing to run in the background.

    `curl 'localhost:3001/shipping?itemId=AAA&type=overnight'`{{execute}}

4. Explore docker commands

    There is a lot of Docker commands to monitor and manage docker containers and images. For details see
    [https://docs.docker.com/engine/reference/commandline/docker/](https://docs.docker.com/engine/reference/commandline/docker/)

    Basic info about the config of docker in your environment (including number of containers running):

    `docker info`{{execute}}

    List the images you have:

    `docker images`{{execute}}

    Examine your docker image to see low level info:

    `docker image inspect lab-cnb/shipping-service-js`{{execute}}

    View the history of what has happened to your image:

    `docker history lab-cnb/shipping-service-js`{{execute}}

    View stats on running containers:

    `docker stats`{{execute}}

    Before we move on, let's stop our running container:

    `docker kill shipping-service-js`{{execute}}
