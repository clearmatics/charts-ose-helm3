#!/usr/bin/env bash

# helm installed and configured
# kubectl instaled and configured
# aws cli instaled and configured

CHART_NAME=autonity-network
S3_BUCKET_NAME=charts-ose.clearmatics.com
RELEASE=0.2.8

echo "INFO: Build "${CHART_NAME}-${RELEASE}

cd ./stable/${CHART_NAME}

if [ $(cat Chart.yaml |grep version: |cut -d" " -f2) != ${RELEASE} ]; then
  echo "ERROR: Release version in git tag do not match with version defined in Chart.yaml"
  exit 1
fi

# Deploy to the cluster
helm install -n build-${CHART_NAME} --namespace build-${CHART_NAME} ./

# Test release
helm test build-${CHART_NAME}

# Delete
helm delete build-${CHART_NAME} --purge
kubectl delete namespace build-${CHART_NAME}

mkdir -p ../../repo

aws s3 sync s3://${S3_BUCKET_NAME} ../../repo

if [ -f "../../repo/"${CHART_NAME}-${RELEASE}.tgz ]; then
    echo "ERROR: Chart ${CHART_NAME}-${RELEASE} already exist in repo"
    exit 1
fi

helm package ./ -d "../../repo" --save=false --debug

helm repo index ../../repo

echo "INFO: Commit "${CHART_NAME}-${RELEASE}" to the repo "${S3_BUCKET_NAME}

aws s3 cp ../../repo/${CHART_NAME}-${RELEASE}.tgz s3://${S3_BUCKET_NAME}
aws s3 cp ../../repo/index.yaml s3://${S3_BUCKET_NAME}

echo "INFO: SUCCESS"
