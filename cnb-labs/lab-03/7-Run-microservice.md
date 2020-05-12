
Our created and tested code is not a running microservice yet. To our functional modules to become a service we need to expose an HTTP endpoint. One of the most popular libraries for this is [express.js](https://expressjs.com)

1. Let us add it to the project:

    `npm i express --save`{{execute}}

1. After installing express package we need to create an entry point of the web service. Typically the entry file is named `app.js` or `index.js`. We will use `app.js`:

    `touch src/app.js`{{execute}}

1. Let us add the minimum config to run an HTTP service to `shipping-service/src/app.js`{{open}}:

    <pre class="file hljs js"  data-filename="shipping-service/src/app.js" data-target="replace">
    const express = require('express')
    const app = express()

    app.get('/*shipping', (request, response) => {
        response.send('It works!')
    })

    app.listen(3000, () => console.log('ShippingService is listening on port 3000'))
    </pre>

1. It can be run buy using:

    `node src/app.js`{{execute}}

    The output should be:

    ```sh
    ShippingService is listening on port 3000
    ```

    By opening [https://[[HOST_SUBDOMAIN]]-3000-[[KATACODA_HOST]].environments.katacoda.com/shipping](https://[[HOST_SUBDOMAIN]]-3000-[[KATACODA_HOST]].environments.katacoda.com/shipping) you will see that service is responding

1. Let's add some flesh on this skeleton. Our service should respond to HTTP GET requests with given arguments of `itemId` and shipping `type`. Let's modify the header to extract those path parameters.

    <pre class="file hljs js" data-target="clipboard">
    app.get('/*shipping', (request, response) => {
    </pre>

1. Those parameters will be stored in `request.query` array variable. Our implementation logic is in the module `shipping-controller.js`. We should require it, and use its methods to generate response.

<pre class="file hljs js" data-target="clipboard">
  // src/app.js
  const express = require('express')
  const app = express()
  const ShippingController = require('../src/controllers/shipping-controller')

  app.get('/*shipping', (request, response) => {
    let ctrl = new ShippingController()

    ctrl
      .getItemShipping({id: request.query.itemId, type: request.query.type})
      .then(amount => {
        response.send({ itemId: request.query.itemId, priceUSD: amount })
      })

  })

  app.listen(3000, () => console.log('ShippingService is listening on port 3000'))
</pre>

1. Here our app includes `ShippingController`, creates it's instance, and calls `getItemShipping` method with given request parameters. It should work, at least in very optimistic scenario. But services sometimes fail, errors happen. In our case, we call one external service (from `product-service`), and have no error handling for the failures. Lets add some general error handling on the main method to deal with possible errors in the `app.js`:

<pre class="file hljs js" data-target="clipboard">
  .catch(error => {
    response.status(500).send({ error: error.message })
  })
</pre>

Please refer to the step 27 for the exact code placement
  
1. If you have tried to run the code at this point, you will notice, that there is an error, which prevents service from returning actual result. It is connected with the factor No. 3 from the [12 factor app](https://12factor.net/), which is called "Config". It requires to store configuration in the environment. In real world application, we should create, or even better - use some existing library to manage our configuration between environments. But to keep things simple, here we will just use few environment variables for the main options: application port and product service url. This will require some minor changes. In the `app.js` we use `process.env.PORT` variable to override default service port:

<pre class="file hljs js" data-target="clipboard">
  let PORT = process.env.PORT || 3000;
  app.listen(PORT, () => console.log(`ShippingService is listening on port ${PORT}`))
</pre>

1. In `product-service.js` we will start using environment-provided `MICROS_PRODUCTS_URL` variable for products microservice. It uses default value, in case environment variable is not set:

<pre class="file hljs js" data-target="clipboard">
  let URL = process.env.MICROS_PRODUCTS_URL || 'product.service:8899/products';
  return axios
    .get(`https://${URL}/${productId}`)
</pre>

Please refer to the step 27 for the exact code placement

1. When running application locally, we just set environment variable in the same shell as the app will be run, or in, for example, debug config. Environment variables locally are set like this:

`export MICROS_PRODUCTS_URL=v7a4m6m4.hostrycdn.com/product-service/products`{{execute}}

1. With correct environment setup you can make your service to use any external service you require.

      Full source for `app.js`:

<pre class="file hljs js" data-target="clipboard">
  // contents of src/app.js
  const express = require('express')
  const app = express()
  const ShippingController = require('../src/controllers/shipping-controller')

  app.get('/*shipping', (request, response) => {
    let ctrl = new ShippingController()

    ctrl
      .getItemShipping({id: request.query.itemId, type: request.query.type})
      .then(amount => {
        response.send({ itemId: request.query.itemId, amount: amount })
      })
      .catch(error => {
        response.status(500).send({ error: error.message })
      })
  })
  let PORT = process.env.PORT || 3000;
  app.listen(PORT, () => console.log(`ShippingService is listening on port ${PORT}`))
  ```

  And `product-service.js`:

  ```js
  // src/services/product-service.js
  var axios = require('axios')

  module.exports = {
    getProductWeight: async function (productId) {
      let URL = process.env['MICROS_PRODUCTS_URL'] || 'product.service:8899/products';
      return axios
        .get(`https://${URL}/${productId}`)
        .then(response => {
          if (response.data && !Number.isNaN(parseFloat(response.data.weightLB))) {
            return response.data.weightLB
          } else {
            return Promise.reject('Invalid response object')
          }
        })
        .catch( (err) => {
          throw new Error(err)
        })
    }
  }
</pre>

That's it! You can test your service by invoking the call at [https://[[HOST_SUBDOMAIN]]-3000-[[KATACODA_HOST]].environments.katacoda.com/shipping?itemId=AAA&type=regular](https://[[HOST_SUBDOMAIN]]-3000-[[KATACODA_HOST]].environments.katacoda.com/shipping?itemId=AAA&type=regular). You should see something similar to:

<pre class="file hljs json">
  {"itemId":"AAA","amount":0.5}
</pre>

Our code became a runnable microservice. For real-world application it still needs a lot of work, like correct, separated structure, proper routing, security, logging, error handling, etc. But nonetheless it works, has minimal configuration, and can be prepared for deployment to the cloud.
