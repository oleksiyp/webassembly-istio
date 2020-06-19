#!/bin/bash

cd $(dirname $0)

helm upgrade -i service2 . --set image.repository=service2 --set fullnameOverride=service2
