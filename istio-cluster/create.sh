#!/usr/bin/env bash

cd $(dirname $0)

#KIND
kind create cluster --name k8s-cluster --config cluster.yaml


# ISTIO
istioctl operator init

kubectl create ns istio-system
kubectl apply -f istio.yaml
kubectl label namespace default istio-injection=enabled

# WASME
kubectl apply -f https://github.com/solo-io/wasme/releases/latest/download/wasme.io_v1_crds.yaml
kubectl apply -f https://github.com/solo-io/wasme/releases/latest/download/wasme-default.yaml

#DASHBOARD
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.1/aio/deploy/alternative.yaml

# service principal token to login to dashboard
kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default
token=$(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 --decode)
echo "TOKEN: " $token
