#!/usr/bin/env bash

# helm installed and configured
# aws cli instaled and configured
# Usage:
# ./ci/deploy_to_repo.sh S3_BUCKET_NAME $CHART_NAME $RELEASE_VERSION


S3_BUCKET_NAME=$1
CHART_NAME=$2
RELEASE=$3

echo "INFO: Build "${CHART_NAME}-${RELEASE}

mkdir -p repo

aws s3 sync s3://${S3_BUCKET_NAME} repo
if [ ! $? -eq 0 ]; then
    echo "ERROR: can't download repo from s3 bucket"
    exit 1
fi

if [ -f "./repo/"${CHART_NAME}-${RELEASE}.tgz ]; then
    echo "ERROR: Chart ${CHART_NAME}-${RELEASE} already exist in repo"
    exit 1
fi

helm package ./stable/${CHART_NAME} -d "repo" --save=false --debug
if [ ! $? -eq 0 ]; then
    echo "ERROR: can't build chart"
    exit 1
fi

helm repo index ./repo
if [ ! $? -eq 0 ]; then
    echo "ERROR: can't index repo"
    exit 1
fi

echo "INFO: Commit "${CHART_NAME}-${RELEASE}" to the repo "${S3_BUCKET_NAME}

aws s3 cp ./repo/${CHART_NAME}-${RELEASE}.tgz s3://${S3_BUCKET_NAME} --metadata-directive REPLACE --cache-control max-age=0,no-cache,no-store,must-revalidate
if [ ! $? -eq 0 ]; then
    echo "ERROR: can't copy chart to S3 bucket"
    exit 1
fi

aws s3 cp ./repo/index.yaml s3://${S3_BUCKET_NAME}
if [ ! $? -eq 0 ]; then
    echo "ERROR: can't update index in S3 bucket"
    exit 1
fi

echo "INFO: SUCCESS"
