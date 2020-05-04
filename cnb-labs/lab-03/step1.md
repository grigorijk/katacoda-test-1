## Setup

For this exercise you should use directory, cloned from your github repository `shipping-service`. Open the shipping-service folder in VSCode and then open the terminal view in VSCode.

`mkdir -p shipping-service && cd shipping-service`{{execute}}

**!NB**: For windows users please ensure the VSCode terminal is set to bash.
  
Then, assuming you already have `node` and `npm` installed, run the following commands:

`npm init -y`{{execute}}

`npm i jest -g`{{execute}}

First command initializes our project by creating `package.json` file with default (or provided) values. It is the core of each javascript application based on npm. If auto-init fails, try running it without `-y` argument, and provide the values.

Second one installs `jest` testing library globally. And makes `jest` command available.

Sometimes Jest takes a bit more time to start, than desired. To speed it up, we need to add few lines to the `package.json`{{open}} file (might be right after "license"):

`json
,
"jest": {
"testEnvironment": "node"
}`{{copy}}

Latter commands install libraries `axios` (which is used in the main code) and `sinon`, `nock`, which are used only at development/testing time.