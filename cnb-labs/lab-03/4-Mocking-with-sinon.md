We have created shipping controller object `shippingCtrl`. The test itself asynchronously called method `getItemShipping`, and expected result of `0.5`. For now it makes no sense, since code and test does not know initial data, which should be provided by product service. For this test to work we need to implement logic in the controller method, and mock the data.

For mocking we will use `sinon` library that is already added to `shipping-service/package.json`{{open}}. Sinon's purpose is to mock, or in other words, replace actual implementations of objects or functions, with the ones we need for the test.

1. Let's add another test case to `shipping-service/tests/shipping-controller.test.js`{{open}} to ensure that it covers variety of test values:

  <pre class="file hljs js" data-target="clipboard">
      it('Should calculate correct shipping for id: 2 ', async function () {
        let shipping = await shippingCtrl.getItemShipping({ id: 2, type: 'standard' })
        expect(shipping).toBe(0.7)
      })
  </pre>

Jest tests should fail now

1. Let's write some logic in our controller and find out the candidate for mocking:

    <pre class="file hljs js" data-filename="shipping-service/tests/shipping-controller.test.js" data-target="replace">
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

1. From the code it is visible, that we are using `productService` to get the item weight. But we do not have any service yet. Since the service is external, it is not subject of our unit tests. Thus we need to decouple it from our tests by replacing its implementation with the mock version. For that we still need to have an adapter to call, therefore we will create an empty module with a singe method in the `src/services` folder:

    `mkdir -p src/services`{{execute}}

    `touch src/services/product-service.js`{{execute}}

    <pre class="file hljs js" data-filename="shipping-service/src/services/product-service.js" data-target="replace">
        module.exports = {
            getProductWeight: async function(productId) {
            // Meanwhile it can be implemented by other developers
            }
        }
    </pre>

1. Then, we can mock it with `sinon.stub()` method in our test:

    <pre class="file hljs js" data-filename="shipping-service/tests/shipping-controller.test.js" data-target="replace">
        var sinon = require('sinon')
        var ShippingController = require('../src/controllers/shipping-controller')
        var productService = require('../src/services/product-service')

        describe('Shipping controller', function () {
            var shippingCtrl = new ShippingController()

            beforeEach(function(){
                sinon.stub(productService, 'getProductWeight').callsFake(async function() {
                    return new Promise(function (resolve, reject) {
                        setTimeout(() => {
                            resolve(5)
                        }, 50)
                    })
                })
            })

            afterEach(function () {
                productService.getProductWeight.restore()
            })

            it('Should calculate correct shipping ', async function () {
                let shipping = await shippingCtrl.getItemShipping({ id: 1, type: 'standard' })
                expect(shipping).toBe(0.5)
            })
            it('Should calculate correct shipping for id: 2 ', async function () {
                let shipping = await shippingCtrl.getItemShipping({ id: 2, type: 'standard' })
                expect(shipping).toBe(0.7)
            })
        })
    </pre>

   `sinon.stub` method takes object to work on, and method name to mock. `callsFake` takes a function, which is a replacement of the original one.
   Our mock implementation returns `Promise` object and resolves it after 50 milliseconds with the value of `0.5`. The test now passes, since it gets required data from product service, and returns expected result for regular shipping type
