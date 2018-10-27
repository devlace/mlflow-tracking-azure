#!/bin/bash

set -o allexport
source .env
set +o allexport

# AZURE_STORAGE_ACCOUNT_NAME=
# AZURE_STORAGE_ACCESS_KEY=
# AZURE_STORAGE_CONTAINER_NAME=
# SHARE_MNT_PATH=

docker run -d \
    -e AZURE_STORAGE_ACCESS_KEY='$AZURE_STORAGE_ACCESS_KEY' \
    -e MLFLOW_SERVER_FILE_STORE='$SHARE_MNT_PATH/mlruns' \
    -e MLFLOW_SERVER_DEFAULT_ARTIFACT_ROOT='wasbs://$AZURE_STORAGE_CONTAINER_NAME@$AZURE_STORAGE_ACCOUNT_NAME.blob.core.windows.net/mlartefacts' \
    -p 5000:5000 \
    devlace/mlflowserver-azure:latest