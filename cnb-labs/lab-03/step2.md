## Testing with _Jest_

  1. In our project folder create new folder `tests`, and the first test file inside it: `shipping-controller.test.js`. Using your favourite IDE (VSCode is recommended for javascript) create your empty test suite, using the `describe` syntax:

      ```javascript
      // File tests/shipping-controller.test.js
      describe('Shipping Controller', function() {
          // Test cases will go here
          it('Canary test', () => {})
      })
      ```

      We also have added one empty test, using `it()`, because _Jest_ test suite should have at least one test.

  2. Now let's run all tests in our folder:

      ```sh
      jest tests --watch
      ```

      Here second argument `tests` directs to the folder, where the test files are stored. Option `--watch` tells jest to not exit after run, and keep looking for further test file changes. When changes are found, tests are re-run. This enables 'testing on the fly', which is pretty handy in TDD.

      After running our empty test suite with an empty test, we get result:

      ```text
       PASS  tests/shipping-controller.test.js
      Shipping Controller
        ✓ Canary test

      Test Suites: 1 passed, 1 total
      Tests:       1 passed, 1 total
      Snapshots:   0 total
      Time:        0.094s, estimated 1s
      ```

      Results are correct, since we don't have any real test cases yet, just an empty test with zero failures.
  
  3. Let's push the code into code repository. You should have github.com account for that, and have repository `shipping-service` already created in there. Since your current folder is cloned from github, just type the following commands in terminal:

        ```shell
        git add tests package.json
        git commit -m "initial commit"
        git push
        ```

        Validate in browser that all files are uploaded successfully.