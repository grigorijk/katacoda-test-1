## Setup

  1. For this exercise you should use directory, cloned from your github repository `shipping-service`. Open the shipping-service folder in VSCode and then open the terminal view in VSCode.
  
  **!NB**: For windows users please ensure the VSCode terminal is set to bash.
  
   Then, assuming you already have `node` and `npm` installed, run the following commands:

      ```sh
      npm init -y
      sudo npm i jest -g
      ```

      First command initializes our project by creating `package.json` file with default (or provided) values. It is the core of each javascript application based on npm. If auto-init fails, try running it without `-y` argument, and provide the values.

      Second one installs `jest` testing library globally. And makes `jest` command available.

      Sometimes Jest takes a bit more time to start, than desired. To speed it up, we need to add few lines to the `package.json` file (might be right after "license"):

      ```json
      "jest": {
        "testEnvironment": "node"
      },
      ```

      Latter commands install libraries `axios` (which is used in the main code) and `sinon`, `nock`, which are used only at development/testing time.