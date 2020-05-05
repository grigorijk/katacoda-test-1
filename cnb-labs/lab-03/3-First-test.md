1. Let's create our first test case

For that we take simplified business requirements from shipping service of microservices game:

   1. Service should return shipping price for the individual item by given product id and shipping type
   2. Service uses product weight provided by `product service` running externally via REST
   3. Regular shipping price is 1/10 x of product weight
   4. Overnight shipping price is 10 x of regular shipping price

1. Since now we have requirements we can write first test and expect it fail. Create the following test case in `shipping-service/tests/shipping-controller.test.js`{{open}}

   <pre class="file hljs js" data-filename="shipping-service/tests/shipping-controller.test.js" data-target="append">
   // tests/shipping-controller.test.js
   var ShippingController = require('../src/controllers/shipping-controller')

   describe('Shipping controller', function () {
     var shippingCtrl = new ShippingController()

     it('Should calculate correct shipping ', async function () {
       let shipping = await shippingCtrl.getItemShipping({ id: 1, type: 'standard' })
       expect(shipping).toBe(0.5)
     })

   })
   </pre>

You can see that jest output has changed to a different one

2. Lets define an empty method, in the shipping controller, called `getItemShipping`. Create file `shipping-controller.js` in  `src/controllers` folder:

`mkdir -p src/controllers`{{execute interrupt}}

`touch src/controllers/shipping-controller.js`{{execute}}

1. Add the following contents with contents to it `shipping-service/src/shipping-controller.js`{{open}}:

  <pre class="file hljs js" data-filename="shipping-service/src/shipping-controller.js" data-target="replace">
    // src/controllers/shipping-controller.js
    class ShippingController{

      constructor() {}

      getItemShipping(item) {}

    }

    module.exports = ShippingController
  </pre>

If you run the `jest tests --watch`{{execute}} command the tests will fail. That's expected since there is no business logic implementation yet
