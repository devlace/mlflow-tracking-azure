#####################
# Deploy ARM template

rg_name=
rg_location=
echo "Creating resource group: $rg_name"
az group create --name "$rg_name" --location "$rg_location"

echo "Deploying resources into $rg_name"
arm_output=$(az group deployment create \
    --resource-group "$rg_name" \
    --template-file "./azuredeploy.json" \
    --parameters @"./azuredeploy.parameters.json" \
    --output json)

if [[ -z $arm_output ]]; then
    echo >&2 "ARM deployment failed." 
    exit 1
fi
