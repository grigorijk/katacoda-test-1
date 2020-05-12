
  1. In our project folder create new folder `tests`, and the first test file inside it: `shipping-controller.test.js`:

  <!-- <pre class="file hljs bash" data-target="clipboard">
    mkdir -p tests
    touch tests/shipping-controller.test.js
  </pre> -->

  `mkdir -p tests && touch tests/shipping-controller.test.js`{{execute}}

  1. Create your empty test suite, using the `describe` syntax in `shipping-service/tests/shipping-controller.test.js`{{open}}:

  <pre class="file hljs js" data-filename="shipping-service/tests/shipping-controller.test.js" data-target="replace">
    describe('Shipping Controller', function() {
        // Test cases will go here
        it('Canary test', () => {})
    })
  </pre>

  We also have added one empty test, using `it()`, because _Jest_ test suite should have at least one test.

  1. Now let's run all tests in our folder:

  `jest tests --watch`{{execute}}

  The first argument `tests` points to the folder, where the test files are stored. Option `--watch` tells jest to not exit after run and keep looking for further test file changes. When changes are found tests are re-run. This enables 'testing on the fly' which is pretty handy in TDD.

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

  <!-- 1. Let's push the code into code repository. You should have github.com account for that, and have repository `shipping-service` already created in there. Since your current folder is cloned from github, just type the following commands in terminal:

  <pre class="file hljs bash" data-target="clipboard">
  git add tests package.json
  git commit -m "initial commit"
  git push
  </pre>

  Validate in browser that all files are uploaded successfully -->