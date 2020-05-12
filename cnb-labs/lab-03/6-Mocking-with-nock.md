As mentioned before, we do not implement Product service ourselves. However, we need to call it, so let's create a test suite for the service wrapper `shipping-service/src/services/product-service.js`{{open}} having  `getProductWeight` method that asynchronously returns weight by the given product id

1. Lets create a dedicated set of tests `product-service.test.js` to cover the above requirements:

    `touch tests/product-service.test.js`{{execute}}

2. The test in `shipping-service/tests/product-service.test.js`{{open}} would expect results from a call to `ProductService` wrapper:

    <pre class="file hljs js"  data-filename="shipping-service/tests/product-service.test.js" data-target="replace">
    var productService = require('../src/services/product-service')
    describe('Product service', function () {
        it('Should call http endpoint', async function () {
            let weight = await productService.getProductWeight('13')
            expect(weight).toBe(15.5)
        })
    })
    </pre>

3. After running `jest tests`{{execute}} we can see two test suites with four tests now. The new one, however, is failing:

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

4. To make the test pass, we need to implement HTTP call to the specific endpoint and with the specific format. It is also vital that the wrapper calls correct URL and parses its response properly. For that we need to mock internal http request call of node.js with `nock` library:

    `npm i nock --save-dev`{{execute}}

5. Let's use it in the top of our new test file with the mock response within the specific test case. Replacing the existing code in `shipping-service/tests/product-service.test.js`{{open}} with the below one:

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

    `nock` takes over HTTP request to the specified URL and returns our provided object (after delaying for a few milliseconds). Notice the special instruction at the beginning of the test that helps `jest tests`{{execute}} to handle mocked requests

6. We will use `axios` library to call remote HTTP endpoints:

    `npm i axios`{{execute}}

7. Now we need to implement actual call logic by using `axios` library in `shipping-service/src/services/product-service.js`{{open}} by adding the following code:
    <pre class="file hljs js"  data-filename="shipping-service/src/services/product-service.js" data-target="replace">
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

     `axios` library makes HTTP request and returns `Promise` object that is handled in the `shipping-controller`. During the `axios.get` method `nock` takes over the http call part and returns mocked data.

     Method `getProductWeight` does not need any alterations to deal with mock logic and `jest tests`{{execute}} result matches our expectation.

8. All tests pass now. Should we stop here? What should happen when the external service returns incorrect response? 

   Let's write one more test case in the `shipping-service/tests/product-service.test.js`{{open}} for error scenario. Place the code in the file before the last `})`:

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

    `nock` responds with an incorrect data structure which makes `getProductWeight` to return rejected promise. Thus the test expect `catch` clause to be executed with the expected error message. `then` clause is not expected to run for in this test case, thus our `jest tests`{{execute}} go red

9. Let us improve `shipping-service/src/services/product-service.js`{{open}} implementation to cover this case:

    <pre class="file hljs js"  data-filename="shipping-service/src/services/product-service.js" data-target="replace">
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

    Additional check handles the case with malformed data and `jest tests`{{execute}} are back green!
