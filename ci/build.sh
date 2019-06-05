#!/usr/bin/env bash

# helm installed and configured
# kubectl instaled and configured
# aws cli instaled and configured

CHART_NAME=autonity-network

echo ${CHART_NAME}

cd ./stable/${CHART_NAME}
ls
