
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

1. Use the following command to run it:

    `node src/app.js`{{execute}}

    The output should be:

    ```sh
    ShippingService is listening on port 3000
    ```

    By opening https://[[HOST_SUBDOMAIN]]-3000-[[KATACODA_HOST]].environments.katacoda.com/shipping you will see that service is responding

2. Let us add some flesh on this skeleton. Our service should respond to HTTP GET requests with given query parameters: `itemId` and shipping `type`. The parameters are resolved in `shipping-service/src/app.js`{{open}} by using `request.query` array variable and then passed to `shipping-controller.js`:

    <pre class="file hljs js" data-filename="shipping-service/src/app.js" data-target="replace">
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

3. Our app includes `ShippingController`, creates its instance and calls `getItemShipping` method with the resolved query parameters. To handle potential errors when calling `product-service` the main method to deal with possible errors in the `shipping-service/src/app.js`{{open}}:

    <pre class="file hljs js" data-target="clipboard">
        // should be right after then statement closure
        .catch(error => {
            response.status(500).send({ error: error.message })
        })
    </pre>

1. Try running the code again:

   `node src/app.js`{{execute interrupt}}

   https://[[HOST_SUBDOMAIN]]-3000-[[KATACODA_HOST]].environments.katacoda.com/shipping?itemId=AAA&type=regular
  
2. When running the code at this point you have noticed that there is an error that prevents service from returning actual result. It is related to the factor No. 3 from the [12 factor app](https://12factor.net/) that is called "Config". This factor requires decoupling application code and configuration. Let us use the simplest approach and create a couple of environment variables to configure application port and product service URL. This will require some minor changes. Update the `shipping-service/src/app.js`{{open}} to use `process.env.PORT` variable to override default service port:

    <pre class="file hljs js" data-target="clipboard">
    let PORT = process.env.PORT || 3000;
    app.listen(PORT, () => console.log(`ShippingService is listening on port ${PORT}`))
    </pre>

3. Update `shipping-service/src/services/product-service.js`{{open}} with the `PRODUCT_SERVICE_URL` variable for products microservice:

    <pre class="file hljs js" data-target="clipboard">
    let URL = process.env.PRODUCT_SERVICE_URL || 'product.service:8899/products';
    return axios
        .get(`https://${URL}/${productId}`)
    </pre>

4. Set environment variable to point to the external product service:

    `export PRODUCT_PRODUCTS_URL=v7a4m6m4.hostrycdn.com/product-service/products`{{execute interrupt}}

5. This variable value can be changed to point to any other product service provider. The full source for `shipping-service/src/app.js`{{open}} should now look as follows:

    <pre class="file hljs js"  data-filename="shipping-service/src/app.js" data-target="replace">
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
    </pre>

6. `shipping-service/src/services/product-service.js`{{open}} should looks as follows:
    <pre class="file hljs js"  data-filename="shipping-service/src/services/product-service.js" data-target="replace">
    var axios = require('axios')
    module.exports = {
        getProductWeight: async function (productId) {
            let URL = process.env['PRODUCT_SERVICE_URL'] || 'product.service:8899/products';
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

7. Run the express service to see the applied changes:

    `node src/app.js`{{execute}}

8. That's it! You can test your service by invoking the call at https://[[HOST_SUBDOMAIN]]-3000-[[KATACODA_HOST]].environments.katacoda.com/shipping?itemId=AAA&type=regular . You should see something similar to:

    <pre class="file hljs json">
        {
            "itemId":"AAA",
            "amount":0.5
        }
    </pre>

    Our code became a runnable microservice. For real-world application it still needs a lot of work, like correct, separated structure, proper routing, security, logging, error handling, etc. But nonetheless it works, has minimal configuration, and can be prepared for deployment to the cloud.
