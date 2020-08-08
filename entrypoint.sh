#!/usr/bin/env bash

cd /usr/src/app
./route53.sh

# Original Entrypoint from your original Dockerfile:
exec node stats.js config.js # example