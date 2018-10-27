[![Build Status](https://msdevlace.visualstudio.com/MLDevOps/_apis/build/status/devlace.mlflow-tracking-azure/mlflowserver-azure-master)](https://msdevlace.visualstudio.com/MLDevOps/_build/latest?definitionId=18)

# MLFlow Tracking Server on Azure
This repository provides necessary artefacts to quicky and easily deploy an [MLflow Tracking server](https://mlflow.org/docs/latest/tracking.html) on Azure. 

[MLflow](https://mlflow.org/docs/latest/index.html) is an open source platform for managing the end-to-end machine learning lifecycle.

## Deployment Options
All deployment options come with an automated deployment script. Select one of the following for deployment instructions/scripts:
- [Deploy to Azure Container Instances (ACI)](deploy-aci/README.md)
- [Deploy to Azure Kubernetes Service (AKS)](deploy-aks/README.md)
- Azure Ubuntu Virtual Machine - **TODO**


*DISCLAIMER*: These deployment scripts do not come with security measures in place. As per recommendation from [MLflow documentation](https://mlflow.org/docs/latest/tracking.html#networking):
> If running a server in production, we would recommend not exposing the built-in server broadly (as it is unauthenticated and unencrypted), and instead putting it behind a reverse proxy like NGINX or Apache httpd, or connecting over VPN. 


## More Information
- [MLFlow](https://mlflow.org/docs/latest/index.html) 
- [Azure Container Instances](https://azure.microsoft.com/en-gb/services/container-instances/)
- [Azure Kubernetes Service](https://azure.microsoft.com/en-au/services/kubernetes-service/)
- [Azure Virtual Machine](https://azure.microsoft.com/en-au/services/virtual-machines/)