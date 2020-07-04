#!/bin/bash

cd $(dirname $0)
set -o xtrace

kubectl proxy >/dev/null 2>&1  &
sleep 3
google-chrome http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/workloads?namespace=istio-system 2>/dev/null

