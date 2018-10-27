# Deploy MLFlow Tracking Server on Azure Kubernetes Service (AKS)

## Deploy

### Requirements: 
- [az cli 2.0+](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Deployment

1. Ensure you are logged-in in the azure cli. 
   - Run `az login` to login.
   - Run `az account set -s <SUBSCRIPTION_ID>` to set target azure subscription.
2. Ensure you are in the `deploy-aks` folder.
3. Open `deploy.sh` and `mlflowtracking.yaml` inspect/change top parameters and environment variables, if necessary.
4. Run `./deploy.sh`.
5. Validate deployment by navigating to the deployed Kubernetes Service IP:port (default: 5000).
   - You can retrieve IP and port by running: 
   - `kubectl get services`
   - NOTE: First time navigating to the web-ui may throw an error initially but I've found this to be transient.
## Architecture
The following shows the architecture of the deployment.

![AKS Architecture](../images/aks-archi.PNG?raw=true "ACI Architecture")

## Logging Data to MLFlow Tracking Server
The following outlines requirements to log data to the MLFlow Tracking Server.

1. Set `MLFLOW_TRACKING` environment variable to the IP:port (default: 5000) of the deployed Tracking Server.
2. Since this deployment uses Azure Blob Storage as the Artifact Store, MLFlow requires either `AZURE_STORAGE_CONNECTION_STRING` or `AZURE_STORAGE_ACCESS_KEY` environment variables set appropriately at server **and at the client** as well.
3. Ensure you have `azure-storage` python installed.
   - Run `pip install azure-storage` to install the package.
  
More information here: https://www.mlflow.org/docs/latest/tracking.html#logging-data-to-runs