#!/usr/bin/env bash

cd $(dirname $0)

ts=`date +"%Y%m%d_%H%M%S"`
wasme build assemblyscript . -t webassemblyhub.io/oleksiyp/random-fail-filter:$ts || exit

wasme push  webassemblyhub.io/oleksiyp/random-fail-filter:$ts || exit

sleep 5

sed < filter.yaml "s/TS/$ts/g" | kubectl apply -f -

