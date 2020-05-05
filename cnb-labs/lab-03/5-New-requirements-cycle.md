  11. Even though our test passes now, it does not cover all the requirements, since there are two types of shipment, and they are priced differently. We will write additional test case to cover overnight shipment.
  
        ```javascript
        // part of tests/shipping-controller.test.js
        it('Should calculate correct overnight shipping ', async function () {
            let shipping = await shippingCtrl.getItemShipping({ id: 1, type: 'overnight' })
            expect(shipping).toBe(5)
        })
        ```

        The test reflects valid business requirement, but it fails again:

        ```text
        FAIL  tests/shipping-controller.test.js
          Shipping controller
            ✓ Should calculate correct shipping  (69ms)
            ✕ Should calculate correct overnight shipping  (70ms)

          ● Shipping controller › Should calculate correct overnight shipping

          expect(received).toBe(expected) // Object.is equality

          Expected: 5
          Received: 0.5

          ...

          Test Suites: 1 failed, 1 total
          Tests:       1 failed, 1 passed, 2 total
        ```

  12. We are mocking the same result from the `productService`, but the `type` of the item is passed different, so the calculations must reflect that. Let’s alter implementation, to make this test happy: replace the existing `async getItemShipping(item)` function in the controller with below code

        ```javascript
        // part of src/controllers/shipping-controller.js
        async getItemShipping(item) {
          var shippingAmount = await productService.getProductWeight(item.id)
          if (item.type.toLowerCase() === 'overnight') {
            return shippingAmount * this.OVERNIGHT_PRICE
          } else {
            return shippingAmount * this.REGULAR_PRICE
          }
        }
        ```

        Implementation now calculates different prices per requirement, and both tests are passing.

        ```text
        PASS  tests/shipping-controller.test.js
        Shipping controller
          ✓ Should calculate correct shipping  (65ms)
          ✓ Should calculate correct overnight shipping  (55ms)
        ```
