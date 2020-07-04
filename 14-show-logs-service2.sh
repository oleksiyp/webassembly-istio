#!/bin/bash

cd $(dirname $0)

kubectl get pods

POD=$(kubectl get pods -o name | grep service2)
kubectl logs $POD -c service-chart

