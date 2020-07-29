#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace # For debugging

#####################
# CONFIGURE PARAMS

# Resource Group name and location
RG_NAME=mlflowserver-aci-rg-01
RG_LOCATION=australiaeast

ACI_IMAGE=xtellurian/mlflowserver-azure:1.8.0
ACI_CONTAINER_NAME=mlflowserver
ACI_DNS_LABEL=aci-mlflow-dns
ACI_STORAGE_ACCOUNT_NAME=storage$RANDOM
ACI_STORAGE_CONTAINER_NAME=acicontainer
ACI_SHARE_MNT_PATH=/mnt/azfiles
ACI_SHARE_NAME=acishare
ACI_MEMORY=2

MLFLOW_SERVER_FILE_STORE=$ACI_SHARE_MNT_PATH/mlruns
MLFLOW_SERVER_DEFAULT_ARTIFACT_ROOT=wasbs://$ACI_STORAGE_CONTAINER_NAME@$ACI_STORAGE_ACCOUNT_NAME.blob.core.windows.net/mlartefacts
MLFLOW_SERVER_HOST=0.0.0.0
MLFLOW_SERVER_PORT=5000

#################
# DEPLOY

echo "Creating resource group: $RG_NAME"
az group create --name "$RG_NAME" --location "$RG_LOCATION"

echo "Creating storage account: $ACI_STORAGE_ACCOUNT_NAME"
az storage account create \
    --resource-group $RG_NAME \
    --location $RG_LOCATION \
    --name $ACI_STORAGE_ACCOUNT_NAME \
    --sku Standard_LRS

# Export the connection string as an environment variable. The following 'az storage share create' command
# references this environment variable when creating the Azure file share.
echo "Exporting storage connection string: $ACI_STORAGE_ACCOUNT_NAME"
export AZURE_STORAGE_CONNECTION_STRING=`az storage account show-connection-string --resource-group $RG_NAME --name $ACI_STORAGE_ACCOUNT_NAME --output tsv`

# Mlflow requires environment variable (AZURE_STORAGE_ACCESS_KEY) to be set at client and with Server
# Export the access keyas an environment variable
echo "Exporting storage keys: $ACI_STORAGE_ACCOUNT_NAME"
export AZURE_STORAGE_ACCESS_KEY=$(az storage account keys list --resource-group $RG_NAME --account-name $ACI_STORAGE_ACCOUNT_NAME --query "[0].value" --output tsv)

echo "Creating the file share for MLFlow FileStore: $ACI_SHARE_NAME"
az storage share create -n $ACI_SHARE_NAME

echo "Creating blob container for MLFlow artefacts: $ACI_STORAGE_CONTAINER_NAME"
az storage container create -n $ACI_STORAGE_CONTAINER_NAME

echo "Deploying container: $ACI_CONTAINER_NAME"
az container create \
    --resource-group $RG_NAME \
    --name $ACI_CONTAINER_NAME \
    --image $ACI_IMAGE \
    --dns-name-label $ACI_DNS_LABEL \
    --ports $MLFLOW_SERVER_PORT \
    --azure-file-volume-account-name $ACI_STORAGE_ACCOUNT_NAME \
    --azure-file-volume-account-key $AZURE_STORAGE_ACCESS_KEY \
    --azure-file-volume-share-name $ACI_SHARE_NAME \
    --azure-file-volume-mount-path $ACI_SHARE_MNT_PATH \
    --memory $ACI_MEMORY \
    --environment-variables AZURE_STORAGE_ACCESS_KEY=$AZURE_STORAGE_ACCESS_KEY \
        MLFLOW_SERVER_FILE_STORE=$MLFLOW_SERVER_FILE_STORE \
        MLFLOW_SERVER_DEFAULT_ARTIFACT_ROOT=$MLFLOW_SERVER_DEFAULT_ARTIFACT_ROOT \
        MLFLOW_SERVER_HOST=$MLFLOW_SERVER_HOST

echo "Completed deployment."