  1. Let's create our first test case

  For that we take simplified business requirements from shipping service of microservices game:

  * Service should return shipping price for the individual item by given product id and shipping type
  * Service uses product weight provided by `product service` running externally via REST
  * Regular shipping price is 1/10 x of product weight
  * Overnight shipping price is 10 x of regular shipping price

  1. Using the first requirement we can write a test and expect it fail. Create the following test case in `shipping-service/tests/shipping-controller.test.js`{{open}}

  <pre class="file hljs js" data-filename="shipping-service/tests/shipping-controller.test.js" data-target="append">
    var ShippingController = require('../src/controllers/shipping-controller')

    describe('Shipping controller', function () {
      var shippingCtrl = new ShippingController()

      it('Should calculate correct shipping ', async function () {
        let shipping = await shippingCtrl.getItemShipping({ id: 1, type: 'standard' })
        expect(shipping).toBe(0.5)
      })

    })
  </pre>

  You can see that `jest tests`{{execute}} output has changed to a different one

  1. Let's define an empty method in the shipping controller called `getItemShipping`. Create file `shipping-controller.js` in  `src/controllers` folder:

  `mkdir -p src/controllers`{{execute}}

  `touch src/controllers/shipping-controller.js`{{execute}}

  1. Add the following contents with contents to it `shipping-service/src/controllers/shipping-controller.js`{{open}}:

  <pre class="file hljs js" data-filename="shipping-service/src/controllers/shipping-controller.js" data-target="replace">
    class ShippingController{

      getItemShipping(item) {
        return 0.5
      }

    }

    module.exports = ShippingController
  </pre>

  If you run the `jest tests`{{execute}} the tests will pass. However, there is no the business logic implementation yet, so we need to write more tests to cover it
