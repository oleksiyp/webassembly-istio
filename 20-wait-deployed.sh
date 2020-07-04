#!/bin/bash

cd $(dirname $0)

watch "kubectl get pods"
