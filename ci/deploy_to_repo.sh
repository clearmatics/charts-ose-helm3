#!/usr/bin/env bash

# helm installed and configured
# aws cli instaled and configured
# Usage:
# ./ci/deploy_to_repo.sh S3_BUCKET_NAME $CHART_NAME $RELEASE_VERSION


S3_BUCKET_NAME=$1
CHART_NAME=$2
RELEASE=$3

echo "INFO: Build "${CHART_NAME}-${RELEASE}

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
