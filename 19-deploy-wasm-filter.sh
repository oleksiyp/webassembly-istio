#!/bin/bash

cd $(dirname $0)

bash -x random-fail/build-push-and-deploy.sh
