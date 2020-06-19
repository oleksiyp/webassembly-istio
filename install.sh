#!/usr/bin/env bash

bash istio-cluster/create.sh
bash service1/build.sh
bash service2/build.sh
bash service-chart/install-service1.sh
bash service-chart/install-service2.sh
