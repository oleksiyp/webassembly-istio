#!/bin/bash

cd $(dirname $0)
set -o xtrace

kubectl port-forward -n istio-system $(kubectl get pods -n istio-system -o name | grep kiali) 20001 >/dev/null 2>&1 &
sleep 3
google-chrome 'http://localhost:20001/kiali/console/graph/namespaces/?edges=noEdgeLabels&graphType=service&namespaces=default&unusedNodes=false&injectServiceNodes=true&duration=60&refresh=15000' 2>/dev/null

