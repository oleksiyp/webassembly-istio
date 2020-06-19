#!/usr/bin/env bash

ts=`date +"%Y%m%d_%H%M%S"`
wasme build assemblyscript . -t webassemblyhub.io/oleksiyp/random-fail-filter:$ts || exit

wasme push  webassemblyhub.io/oleksiyp/random-fail-filter:$ts || exit

sleep 20

wasme pull webassemblyhub.io/oleksiyp/random-fail-filter:$ts || exit

kubectl apply -f - <<EOF
apiVersion: wasme.io/v1
kind: FilterDeployment
metadata:
  name: random-fail-filter
  namespace: default
spec:
  deployment:
    istio:
      kind: Deployment
  filter:
    config: "test"
    image: webassemblyhub.io/oleksiyp/random-fail-filter:$ts
EOF
