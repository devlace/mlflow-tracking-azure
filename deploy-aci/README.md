# Deploy MLFlow Tracking Server on Azure Container Instances

## Deploy

### Requirements: 
- [az cli 2.0+](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

### Deployment
1. Ensure you are logged-in in the azure cli. 
   - Run `az login` to login.
   - Run `az account set -s <SUBSCRIPTION_ID>` to set target azure subscription.
2. Ensure you are in the `deploy-aci` folder.
3. Open `deploy.sh` and inspect/change top parameters, if necessary.
4. Run `./deploy.sh`
5. Validate deployment by navigating to the ACI IP:port (default: 5000). NOTE, that it takes a few moments for the server to startup.
   - You can retrieve IP and port of the deployed Tracking Server on ACI by running: 
   - `az container show --name <ACI_NAME> --resource-group <ACI_RESOURCE_GROUP> --output table`
## Architecture
The following shows the architecture of the deployment.

![ACI Architecture](../images/aci-archi.PNG?raw=true "ACI Architecture")

## Logging Data to MLFlow Tracking Server
The following outlines requirements to log data to the MLFlow Tracking Server.

1. Set `MLFLOW_TRACKING` environment variable to the IP:port (default: 5000) of the deployed Tracking Server.
2. Since this deployment uses Azure Blob Storage as the Artifact Store, MLFlow requires either `AZURE_STORAGE_CONNECTION_STRING` or `AZURE_STORAGE_ACCESS_KEY` environment variables set appropriately at server **and at the client** as well.
3. Ensure you have `azure-storage` python installed.
   - Run `pip install azure-storage` to install the package.
  
More information here: https://www.mlflow.org/docs/latest/tracking.html#logging-data-to-runs