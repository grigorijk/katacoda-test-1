
<!-- For this exercise you should use directory, cloned from your github repository `shipping-service`. Clone it in terminal window using it's https URL: -->

<!-- `git clone <<your git repo's https URL>>`{{copy}} -->
<!-- Open the shipping-service folder in VSCode and then open the terminal view in VSCode. -->
1. Let's start excercise from creating the project folder:

  `mkdir -p shipping-service && cd shipping-service`{{execute}}

  <!-- **!NB**: For windows users please ensure the VSCode terminal is set to bash. -->
    
  <!-- Then, assuming you already have `node` and `npm` installed, run the following commands: -->

1. Then let's initiate the Node.js project by running the following command:

    `npm init -y`{{execute}}

    The command initializes our project by creating `shipping-service/package.json`{{open}} file with default (or provided) values. It is the core of each javascript application based on npm. If auto-init fails, try running it without `-y` argument, and provide the values.

1. Now let's install test running library as a global terminal command:

    `npm i jest -g`{{execute}}

    Try running `jest`{{execute}} in terminal

1. Sometimes Jest takes more time to start than desired. To speed it up we need to add few lines to the `shipping-service/package.json`{{open}} file (might be right after "license"):

    <pre class="file hljs json" data-target="clipboard">
    ,
        "jest": {
            "testEnvironment": "node"
        }
    </pre>

1. We are now ready to start test driven development with node.js

  <!-- Latter commands install libraries `axios` (which is used in the main code) and `sinon`, `nock`, which are used only at development/testing time.

  `npm i axios --save`{{execute}}

  `npm i sinon nock --save-dev`{{execute}} -->
