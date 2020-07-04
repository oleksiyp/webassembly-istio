#!/usr/bin/env bash

cd $(dirname $0)
set -o xtrace

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.3/aio/deploy/recommended.yaml

kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default

TOKEN="$(kubectl get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='default')].data.token}"|base64 --decode)"
