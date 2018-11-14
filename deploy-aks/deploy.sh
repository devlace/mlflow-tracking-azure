#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace # For debugging

#####################
# CONFIGURE PARAMS

RG_NAME=mlflowserver-aks-rg-05
RG_LOCATION=australiaeast

AKS_IMAGE=devlace/mlflowserver-azure:0.8.0
AKS_NAME=mlflowaks
AKS_STORAGE_ACCOUNT_NAME=storage$RANDOM
AKS_STORAGE_CONTAINER_NAME=mlflow

#################
# DEPLOY

echo "Creating resource group: $RG_NAME"
az group create --name "$RG_NAME" --location "$RG_LOCATION"

echo "Creating AKS cluster: $AKS_NAME"
az aks create \
    --resource-group $RG_NAME \
    --name $AKS_NAME \
    --node-count 1 \
    --enable-addons monitoring \
    --generate-ssh-keys

echo "Retrieving credentials of AKS cluster: $AKS_NAME"
az aks get-credentials \
    --resource-group $RG_NAME \
    --name $AKS_NAME

echo "Creating storage account: $AKS_STORAGE_ACCOUNT_NAME"
az storage account create \
    --resource-group $RG_NAME \
    --location $RG_LOCATION \
    --name $AKS_STORAGE_ACCOUNT_NAME \
    --sku Standard_LRS

# Export the connection string as an environment variable. The following 'az storage share create' command
# references this environment variable when creating the Azure file share.
echo "Exporting storage connection string: $AKS_STORAGE_CONTAINER_NAME"
export AZURE_STORAGE_CONNECTION_STRING=`az storage account show-connection-string --resource-group $RG_NAME --name $AKS_STORAGE_ACCOUNT_NAME --output tsv`

echo "Creating blob container for MLFlow artefacts: $AKS_STORAGE_CONTAINER_NAME"
az storage container create -n $AKS_STORAGE_CONTAINER_NAME

# Mlflow requires environment variable (AZURE_STORAGE_ACCESS_KEY) to be set at client and with Server
# Export the access keyas an environment variable
echo "Exporting storage keys: $AKS_STORAGE_ACCOUNT_NAME"
export AZURE_STORAGE_ACCESS_KEY=$(az storage account keys list --resource-group $RG_NAME --account-name $AKS_STORAGE_ACCOUNT_NAME --query "[0].value" --output tsv)

# Build blob storage fqdn of ml artifacts
AKS_STORAGE_FQDN_ARTIFACT="wasbs://$AKS_STORAGE_CONTAINER_NAME@$AKS_STORAGE_ACCOUNT_NAME.blob.core.windows.net/mlartefacts"

echo "Create kubernetes secret"
kubectl create secret generic storage-secret \
    --from-literal=azurestorageaccountartifact="$AKS_STORAGE_FQDN_ARTIFACT" \
    --from-literal=azurestorageaccountkey="$AZURE_STORAGE_ACCESS_KEY"

echo "Deploying MLFlow tracking server to AKS"
kubectl apply -f mlflowtracking.yaml