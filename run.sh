#!/bin/bash

export NODE_VERSION=${NODE_VERSION:-v1.17.0}

kind create cluster --config https://raw.githubusercontent.com/shudipta/play-with-kind/master/kind.yaml --image kindest/node:$NODE_VERSION
echo "waiting for nodes to be ready ..."
kubectl wait --for=condition=Ready nodes --all --timeout=5m
kubectl get nodes
echo
echo "installing local-path provisioner ..."
kubectl delete storageclass --all
kubectl apply -f https://github.com/rancher/local-path-provisioner/raw/v0.0.12/deploy/local-path-storage.yaml
kubectl wait --for=condition=Ready pods -n local-path-storage --all --timeout=5m
kubectl apply -f https://raw.githubusercontent.com/shudipta/play-with-kind/master/storageclass.yaml

echo "Happy kinding ...!"

