As mentioned before, we do not implement Product service ourselves. However, we need to call it, so let's create a service wrapper with a method name `getProductWeight` that asynchronously returns weight by the given product id. 

1. Lets create a dedicated set of tests `product-service.test.js` to cover the above requirements:

  `touch -p tests/product-service.test.js`{{execute}}

1. The test in `shipping-service/tests/product-service.test.js`{{open}} would expect results from a call to `ProductService` wrapper:

  <pre class="file hljs js"  data-filename="shipping-service/tests/product-service.test.js" data-target="replace">
  var productService = require('../src/services/product-service')

  describe('Product service', function () {
    it('Should call http endpoint', async function () {
      let weight = await productService.getProductWeight('13')
      expect(weight).toBe(15.5)
    })
  })
  </pre>

1. After running `jest tests`{{execute}} we can see that there are two test suites with and three tests now. The new one, however, is failing:

  ```text
    PASS  tests/shipping-controller.test.js
    FAIL  tests/product-service.test.js
  ● Product service › Should call http endpoint

  expect(received).toBe(expected) // Object.is equality

  Expected: 15.5
  Received: undefined

  Difference:

    Comparing two different types of values. Expected number but received undefined.
  ```

1. To make the test pass, we need to implement HTTP call to the specific endpoint and with the specific format. We need to make sure that the wrapper calls correct URL and parses its response properly. For that we need to mock internal http request call of node.js with `nock` library:

  `npm i nock --save-dev`{{execute}}

1. Let's use it in the top of our new test file with the mock response within the specific test case. Replacing the existing code in `shipping-service/tests/product-service.test.js`{{open}} with the below one:

  <pre class="file hljs js"  data-filename="shipping-service/tests/product-service.test.js" data-target="replace">
    /**
    * @jest-environment node
    */
    var productService = require('../src/services/product-service')
    var nock = require('nock')

    describe('Product service', function () {
      it('Should call remote service', async function () {
        nock('https://product.service:8899/products')
          .get('/13')
          .delayBody(10)
          .reply(200, {
            weightLB: 15.5,
            unit: 'lbs'
          })

        let weight = await productService.getProductWeight('13')
        expect(weight).toBe(15.5)
      })
    })
  </pre>

  Notice the special comment at the beginning of the test, it helps Jest handle mocked requests.

1. After this call `nock` takes over the request, and returns our provided object (after delaying for a few milliseconds). The test still fails, because we don't have actual implementation yet, and nobody calls it. Let’s create it by running below command and replace the code in `product-service.js` with below

  <pre class="file hljs js" data-target="clipboard">
    // src/services/product-service.js
    var axios = require('axios')

    module.exports = {
      getProductWeight: async function (productId) {
        return axios
          .get('https://product.service:8899/products/' + productId)
          .then(response => {
            return response.data.weightLB
          })
      }
    }
  </pre>

  It uses popular `axios` library to make HTTP request and return `Promise` object, which is handled later in the `shipping-controller`. In the `axios.get` method, `nock` takes over the http call part, and returns mocked data. Method `getProductWeight` runs with no alterations, and result is compared to our expectations.

1. Our test now passes. But what about the cases, when the result from service is not correct? Let's write one more test case in the `tests/product-service.test.js` for it. Place the code in the file before the last `})`

  <pre class="file hljs js" data-target="clipboard">
    it('Should handle unexpected response structure', async function () {
      nock('https://product.service:8899/products')
          .defaultReplyHeaders({ 'access-control-allow-origin': '*' })
          .get('/19')
          .reply(200, {
            res: 15.5
          })

      await productService
          .getProductWeight('19')
          .then(() => {
            throw(new Error('Should not resolve in case of malformed data'))
          })
          .catch(err => {
            expect(err.message).toBe('Invalid response object')
          })
      })
  </pre>

1. This test expects the call to `getProductWeight` to return rejected promise, when the returned data structure is not correct (cannot parse actual weight property). Test should fail, if method resolves with `undefined` or any other result after that. Our tests are failing again. Let's improve implementation:

  <pre class="file hljs js" data-target="clipboard">
    // src/services/product-service.js
    var axios = require('axios')

    module.exports = {
      getProductWeight: async function (productId) {
        return axios
          .get('https://product.service:8899/products/' + productId)
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

  Additional check handles the case with malformed data, and tests are passing again!
