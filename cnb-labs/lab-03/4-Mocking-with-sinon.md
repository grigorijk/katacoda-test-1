So far we have created shipping a controller object and assigned it to `shippingCtrl` variable. 

Our test call asynchronously `getItemShipping` method and expects result of `0.5`. It makes no sense yet since code and test does not know initial data that should be provided by the product service. To make this test work we need to implement business logic in the controller method and provide it with the mock data.

1. For mocking we will use `sinon` library so let's add it to `shipping-service/package.json`{{open}} by running the following command:
    `npm i sinon --save-dev`{{execute}}

    Sinon's purpose is to mock, that is replace actual implementations of objects or functions with the ones we need for the test.

2. Let's add another test case to `shipping-service/tests/shipping-controller.test.js`{{open}} to ensure that it covers variety of test values:

    <pre class="file hljs js" data-target="clipboard">
        it('Should calculate correct shipping for id: 2 ', async function () {
            let shipping = await shippingCtrl.getItemShipping({ id: 2, type: 'standard' })
            expect(shipping).toBe(1)
        })
    </pre>

    Unit tests should start fail now `jest tests`{{execute}}

3. Let's write some logic in our controller `shipping-service/src/controllers/shipping-controller.js`{{open}} and find out the candidate for mocking:

    <pre class="file hljs js" data-filename="shipping-service/src/controllers/shipping-controller.js" data-target="replace">
    var productService = require('../services/product-service')

    class ShippingController {

        constructor() {
            this.REGULAR_PRICE = 0.1
        }

        async getItemShipping(item) {
            var shippingAmount = await productService.getProductWeight(item.id)
            return shippingAmount * this.REGULAR_PRICE
        }

    }

    module.exports = ShippingController;
    </pre>

    The `jest tests`{{execute}} are now failing because of missing service, as we now added logic to call product service adaptor

4. From the code it is visible, that we are using `productService` to get the item weight. But we do not have any service yet. Since the service is external, it is not subject of our unit tests. Thus we need to decouple it from our tests by replacing its implementation with the mock version. For that we still need to have an adapter to call, therefore we will create an empty `project-service.js` module with a singe method in the `src/services` folder:

    `mkdir -p src/services && touch src/services/product-service.js`{{execute}}

    `shipping-service/src/services/product-service.js`{{open}}

    <pre class="file hljs js" data-filename="shipping-service/src/services/product-service.js" data-target="replace">
    module.exports = {
        getProductWeight: async function(productId) {
        // Meanwhile it can be implemented by other developers
        }
    }
    </pre>

    The missing service error should be gone now, but the adaptor yet has no logic to call any external service, so the tests `jest tests`{{execute}} fail

5. Then we can mock it with `sinon.stub()` method in our test `shipping-service/tests/shipping-controller.test.js`{{open}}:

    <pre class="file hljs js" data-filename="shipping-service/tests/shipping-controller.test.js" data-target="replace">
    var sinon = require('sinon')
    var ShippingController = require('../src/controllers/shipping-controller')
    var productService = require('../src/services/product-service')

    describe('Shipping controller', function () {
        var shippingCtrl = new ShippingController()

        beforeEach(function(){
            sinon.stub(productService, 'getProductWeight').callsFake(async function(id) {
                return new Promise(function (resolve, reject) {
                    setTimeout(() => {
                        resolve(id === 1 ? 5 : 10)
                    }, 50)
                })
            })
        })

        afterEach(function () {
            productService.getProductWeight.restore()
        })

        it('Should calculate correct shipping', async function () {
            let shipping = await shippingCtrl.getItemShipping({ id: 1, type: 'standard' })
            expect(shipping).toBe(0.5)
        })
        it('Should calculate correct shipping for a different id', async function () {
            let shipping = await shippingCtrl.getItemShipping({ id: 2, type: 'standard' })
            expect(shipping).toBe(1)
        })
    })
    </pre>

   `sinon.stub` method takes object to work on and method name to mock. `callsFake` takes a function, which is a replacement of the original one.
   Our mock implementation returns `Promise` object and resolves it after 50 milliseconds with the value of `0.5` or `1`.

   The tests `jest tests`{{execute}} now pass because they get required data from product service and return expected result for regular shipping type
