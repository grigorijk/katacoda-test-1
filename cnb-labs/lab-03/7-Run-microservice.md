
  19. Our created and tested code is not a running microservice. In order our functional modules to become a service, we need to expose them as one. Probably the most popular library for this task is **express.js**. Let's install it and see, how much effort it takes. In the terminal, install the latest express and save it as dependency:

      ```npm
      npm i express --save
      ```

  20. After installing express package, we need to create an entry point of the web service. Usually, entry file is named `app.js`, `index.js` and similar. In `src` folder, create one more file, called `app.js`:

      ```javascript
      // contents of src/app.js
      const express = require('express')
      const app = express()

      app.get('/*shipping', (request, response) => {
        response.send('It works!')
      })

      app.listen(3000, () => console.log('ShippingService is listening on port 3000'))
      ```

      It is the one of the shortest possible services with express. You can run it by typing:

      ```sh
      node src/app.js
      ```

      and it will report, that:

      ```sh
      ShippingService is listening on port 3000
      ```

      In the browser, by opening [http://localhost:3000/shipping](http://localhost:3000/shipping) you will see, that service is working. Just not much is done yet.

  21. Let's add some flesh on this skeleton. Our service should respond to HTTP GET requests with given arguments of `itemId` and shipping `type`. Let's modify the header to extract those path parameters.

      ```js
      app.get('/*shipping', (request, response) => {
      ```

  22. those parameters will be stored in `request.params` array variable. Our implementation logic is in the module `shipping-controller.js`. We should require it, and use its methods to generate response.

      ```js
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
      ```

  23. Here our app includes `ShippingController`, creates it's instance, and calls `getItemShipping` method with given request parameters. It should work, at least in very optimistic scenario. But services sometimes fail, errors happen. In our case, we call one external service (from `product-service`), and have no error handling for the failures. Lets add some general error handling on the main method to deal with possible errors in the `app.js`:

      ```js
      .catch(error => {
        response.status(500).send({ error: error.message })
      })
      ```

      Please refer to the step 27 for the exact code placement
  
  24. If you have tried to run the code at this point, you will notice, that there is an error, which prevents service from returning actual result. It is connected with the factor No. 3 from the [12 factor app](https://12factor.net/), which is called "Config". It requires to store configuration in the environment. In real world application, we should create, or even better - use some existing library to manage our configuration between environments. But to keep things simple, here we will just use few environment variables for the main options: application port and product service url. This will require some minor changes. In the `app.js` we use `process.env.PORT` variable to override default service port:

      ```js
      let PORT = process.env.PORT || 3001;
      app.listen(PORT, () => console.log(`ShippingService is listening on port ${PORT}`))
      ```

  25. In `product-service.js` we will start using environment-provided `MICROS_PRODUCTS_URL` variable for products microservice. It uses default value, in case environment variable is not set:

      ```js
      let URL = process.env.MICROS_PRODUCTS_URL || 'product.service:8899/products';
      return axios
        .get(`https://${URL}/${productId}`)
      ```

      Please refer to the step 27 for the exact code placement

  26. When running application locally, we just set environment variable in the same shell as the app will be run, or in, for example, debug config. Environment variables locally are set like this:

      ```bash
        export MICROS_PRODUCTS_URL=product-service-java.eu-gb.mybluemix.net/products
      ```

      **!NB**: Windows users should be able to set an environment variable in one of the following ways for **cmd**:

      ```sh
      set MICROS_PRODUCTS_URL=product-service-java.eu-gb.mybluemix.net/products
      ```

      for Power Shell (not tested):

      ```sh
      [Environment]::SetEnvironmentVariable("MICROS_PRODUCTS_URL","product-service-java.eu-gb.mybluemix.net/products")
      ```

  27. With correct environment setup you can make your service to use any external service you require.

      Full source for `app.js`:

      ```js
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
      let PORT = process.env.PORT || 3001;
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
      ```

      That's it! You can test your service by invoking the call at [http://localhost:3001/shipping?itemId=AAA&type=regular](http://localhost:3001/shipping?itemId=AAA&type=regular). You should see something similar to:

      ```json
      {"itemId":"AAA","amount":0.5}
      ```

      Our code became a runnable microservice. For real-world application it still needs a lot of work, like correct, separated structure, proper routing, security, logging, error handling, etc. But nonetheless it works, has minimal configuration, and can be prepared for deployment to the cloud.
