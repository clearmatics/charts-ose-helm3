#!/usr/bin/env bash

# Usage:
# ./test_candidate_pr.sh

git diff origin/master --name-only

if [ ! $? -eq 0 ]; then
    echo "ERROR: not your day"
    exit 1
fi
