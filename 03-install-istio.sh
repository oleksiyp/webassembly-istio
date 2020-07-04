#!/usr/bin/env bash

cd $(dirname $0)
set -o xtrace

istioctl operator init

kubectl create ns istio-system
kubectl apply -f istio.yaml
kubectl label namespace default istio-injection=enabled

