#!/bin/bash
git clone https://github.com/grigorijk/shipping-service-js
cd shipping-service-js
rm -rf Dockerfile *.yml *.sh .git *.yaml .gitignore .s2i
launch.sh