#!/usr/bin/env bash

cd $(dirname $0)
set -o xtrace

kind create cluster --name k8s-cluster --config cluster.yaml
