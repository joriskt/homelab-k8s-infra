#!/bin/bash

# Command obtained from the Helm install.
# It said to run this to monitor the controller availability.
kubectl get service \
    --namespace ingress-nginx \
    ingress-nginx-controller \
    --output wide \
    --watch
