#! /bin/bash

set -e
npm install serverless
npm i
rm -rf ~/.serverless
# sls deploy --enforce-hash-update --stage $ENV_NAME
SLS_DEBUG=* sls deploy --stage $ENV_NAME --debug