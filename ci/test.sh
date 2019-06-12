#!/usr/bin/env bash

# helm installed and configured
# kubectl instaled and configured
# aws cli instaled and configured
#
# Usage:
# ./test.sh autonity-eks-dev autonity-network 0.2.8
# or
# ./test.sh autonity-eks-dev autonity-network

CLUSTER=$1
CHART_NAME=$2
RELEASE=$3

if [ ! -d "./stable/${CHART_NAME}" ]; then
  echo "INFO: Tests will skipped because chart not found"
  exit 0
fi

cd ./stable/${CHART_NAME}

if [ ! -z "$3" ]
  then
    if [ $(cat Chart.yaml |grep version: |cut -d" " -f2) != ${RELEASE} ]; then
        echo "ERROR: Release version in git tag do not match with version defined in Chart.yaml"
        exit 1
    fi
fi

aws eks update-kubeconfig --name ${CLUSTER}

if [ ! $? -eq 0 ]; then
    echo "ERROR: can't receive token from AWS for connection to the kubernetes cluster"
    exit 1
fi

# Deploy to the cluster
helm install -n build-${CHART_NAME} --namespace build-${CHART_NAME} ./

# Test release
helm test build-${CHART_NAME}
if [ ! $? -eq 0 ]; then
    echo "FAILED: Chart tests failed"
    exit 1
fi

# Delete
helm delete build-${CHART_NAME} --purge
kubectl delete namespace build-${CHART_NAME}
