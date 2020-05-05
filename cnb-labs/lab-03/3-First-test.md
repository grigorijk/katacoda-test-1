  1. Let's create our first test case. For that we take business requirements from shipping service of microservices game. This service should return shipping price for the individual item by given product id. Service uses three other services to calculate that. So, lets define an empty method, in the shipping controller, called `getItemShipping`. Open your favourite text editor, and in the `src/controllers` folder create file, named `shipping-controller.js` with contents:

      ```javascript
      // src/controllers/shipping-controller.js
      class ShippingController{

        constructor() {}

        getItemShipping(item) {}

      }

      module.exports = ShippingController
      ```

  2. Since now we have our empty controller, with visible contract, we can write first test, and expect some results from it: Create the file shipping-controller.test.js in the tests folder and paste below code in to it:

      ```javascript
      // tests/shipping-controller.test.js
      var ShippingController = require('../src/controllers/shipping-controller')

      describe('Shipping controller', function () {
        var shippingCtrl = new ShippingController()

        it('Should calculate correct shipping ', async function () {
          let shipping = await shippingCtrl.getItemShipping({ id: 1, type: 'standard' })
          expect(shipping).toBe(0.5)
        })

      })
      ```

      We have created shipping controller object `shippingCtrl`. The test itself asynchronously called method `getItemShipping`, and expected result of `0.5`. For now it makes no sense, since code and test does not know initial data, which should be provided by product service. For this test to work we need to implement logic in the controller method, and mock the data.

      If you run the `jest tests` command the tests will fail. That's expected