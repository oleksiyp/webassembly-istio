#!/bin/bash

cd $(dirname $0)

POD=$(kubectl get pods -o name | grep service1 | tail -n 1)
kubectl logs $POD -c service-chart --tail=10 -f

