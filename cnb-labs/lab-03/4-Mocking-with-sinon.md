We have created shipping controller object `shippingCtrl`. The test itself asynchronously called method `getItemShipping`, and expected result of `0.5`. For now it makes no sense, since code and test does not know initial data, which should be provided by product service. For this test to work we need to implement logic in the controller method, and mock the data.

7. For mocking we will use `sinon` library. To install it, in command line run:

      ```sh
      npm i sinon --save-dev
      ```

      And in the code, you need to require sinon object:

      ```javascript
      var sinon = require('sinon')
      ```

  8. Sinon's purpose is to mock, or in other words, replace actual implementations of objects or functions, with the ones we need for the test. Lets write some logic in our controller, and find out the candidate for mocking:

      ```javascript
      // src/controllers/shipping-controller.js
      var productService = require('../services/product-service')

      class ShippingController {

        constructor() {
          this.REGULAR_PRICE = 0.1
          this.OVERNIGHT_PRICE = 1
        }

        async getItemShipping(item) {
          var shippingAmount = await productService.getProductWeight(item.id)
          return shippingAmount * this.REGULAR_PRICE
        }

      }

      module.exports = ShippingController;
      ```

  9. From the code it is visible, that we are using `productService` to get the item weight. But we don't have it. Also, it is not our test subject. So we need to separate it from our test by replacing its implementation with the mock version. For that we still need to have the object itself, so in the `src/services` folder we will create empty module with one method:

      ```javascript
      // src/services/product-service.js
      module.exports = {
          getProductWeight: async function(productId) {
            // Meanwhile it can be implemented by other developers
          }
      }
      ```

  10.  Then, we can mock it with `sinon.stub()` method in our test:

        ```javascript
        /* tests/shipping-controller.test.js */
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

        })
        ```

        `sinon.stub` method takes object to work on, and method name to mock. `callsFake` takes a function, which is a replacement of the original one.
        Our mock implementation returns `Promise` object and resolves it after 50 milliseconds with the value of `0.5`. The test now passes, since it gets required data from product service, and returns expected result for regular shipping type.