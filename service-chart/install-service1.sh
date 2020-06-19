#!/bin/bash

cd $(dirname $0)

helm upgrade -i service1 . --set image.repository=service1 --set fullnameOverride=service1
