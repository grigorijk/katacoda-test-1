Although our tests pass now they do not cover all the requirements as there are two types of shipment and they are priced differently. 

1. Let's write additional test case to to `shipping-service/tests/shipping-controller.test.js`{{open}} that covers overnight shipment:

    <pre class="file hljs js" data-target="clipboard">
            it('Should calculate correct overnight shipping ', async function () {
                let shipping = await shippingCtrl.getItemShipping({ id: 1, type: 'overnight' })
                expect(shipping).toBe(5)
            })
    </pre>

    The `jest tests`{{execute}} cover valid business requirement and fail again:

    ```text
    FAIL  tests/shipping-controller.test.js
        Shipping controller
        ✓ Should calculate correct shipping  
        ✓ Should calculate correct shipping for id: 2
        ✕ Should calculate correct overnight shipping  

        ● Shipping controller › Should calculate correct overnight shipping

        expect(received).toBe(expected) // Object.is equality

        Expected: 5
        Received: 0.5

        ...

        Test Suites: 1 failed, 1 total
        Tests:       1 failed, 1 passed, 2 total
    ```

2. We are mocking the same result from the `productService`, but the `type` of the item is passed different, so the calculations must reflect that. Let’s alter implementation, to make this test happy: replace the existing code in the controller `shipping-service/src/controllers/shipping-controller.js`{{open}} with below code:

    <pre class="file hljs js" data-filename="shipping-service/src/controllers/shipping-controller.js" data-target="replace">
    var productService = require('../services/product-service')

    class ShippingController {

        constructor() {
            this.REGULAR_PRICE = 0.1
            this.OVERNIGHT_PRICE = 1;
        }

        async getItemShipping(item) {
            var shippingAmount = await productService.getProductWeight(item.id)
            if (item.type.toLowerCase() === 'overnight') {
                return shippingAmount * this.OVERNIGHT_PRICE
            } else {
                return shippingAmount * this.REGULAR_PRICE
            }
        }
    }

    module.exports = ShippingController;
    </pre>

    This Implementation now calculates different prices per requirement, and all `jest tests`{{execute}} are passing

    ```text
    PASS  tests/shipping-controller.test.js
        Shipping controller
        ✓ Should calculate correct shipping  
        ✓ Should calculate correct shipping for id: 2
        ✓ Should calculate correct overnight shipping  
    ```
