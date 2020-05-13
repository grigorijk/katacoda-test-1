#!/bin/bash
git clone https://github.com/grigorijk/shipping-service-js
mv shipping-service-js/ shipping-service && cd shipping-service
rm -rf Dockerfile *.yml *.sh .git *.yaml .gitignore .s2i
launch.sh