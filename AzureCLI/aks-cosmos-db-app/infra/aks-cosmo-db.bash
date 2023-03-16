# Create Bash variables to store important information like the Azure Cosmos DB account name and the resource group name:
export RESOURCE_GROUP=rg-ship-manager
export COSMOSDB_ACCOUNT_NAME=contoso-ship-manager-$RANDOM
export $LOCATION=eastus2

# Create Resource Group:
az group create -n $RESOURCE_GROUP -l $LOCATION

#Create a new Azure Cosmos DB account:
az cosmosdb create --name $COSMOSDB_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --kind MongoDB

# Check if the creation has finished by creating a new database and listing it:
az cosmosdb mongodb database create --account-name $COSMOSDB_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --name contoso-ship-manager

# Then, list the databases by using the list command:
az cosmosdb mongodb database list --account-name $COSMOSDB_ACCOUNT_NAME --resource-group $RESOURCE_GROUP -o table

# Create Bash variables to store important information like the cluster name and resource group name:
export AKS_CLUSTER_NAME=ship-manager-cluster

# Run the AKS creation script:
az aks create --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME  \
    --node-count 3 \
    --generate-ssh-keys \
    --node-vm-size Standard_B2s \
    --enable-managed-identity \
    --location $LOCATION \
    --enable-addons http_application_routing

# Download the kubectl configuration:
az aks get-credentials --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP

# Test the configuration:
kubectl get nodes

# Replace the {your database connection string} placeholder with the actual connection string from Azure Cosmos DB: [backend-deploy.yml]
az cosmosdb keys list --type connection-strings -g $RESOURCE_GROUP -n $COSMOSDB_ACCOUNT_NAME --query "connectionStrings[0].connectionString" -o tsv

# Apply the update by using the kubectl apply command:
kubectl apply -f backend-deploy.yml

# Replace the {DNS_ZONE} placeholder with your cluster DNS zone. You can get that information by running the following AKS command: [backend-network.yml]
az aks show -g $RESOURCE_GROUP -n $AKS_CLUSTER_NAME -o tsv --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName

# Apply the update by using the kubectl apply command:
kubectl apply -f backend-network.yml

# You can check the status of the DNS zone by querying Kubernetes for the available ingresses, 
# once the ADDRESS field is filled, it means the ingress has been deployed and it's ready to be accessed:
kubectl get ingress

# Replace the {YOUR_BACKEND_URL} placeholder with the URL of the back-end API that you just put in the ingress in the previous step. [frontend-deploy.yaml]
# Apply the template by using kubectl apply:
kubectl apply -f frontend-deploy.yml

# Replace the {DNS_ZONE} placeholder with your cluster DNS zone. You can get that information by using the following AKS command:
az aks show -g $RESOURCE_GROUP -n $AKS_CLUSTER_NAME -o tsv --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName

# Apply the update by using the kubectl apply command:
kubectl apply -f frontend-network.yml

# You can check the status of the DNS zone by querying Kubernetes for the available ingresses, 
# once the ADDRESS field is filled, it means the ingress has been deployed and it's ready to be accessed:
kubectl get ingress

# Cleanup Resources
az group delete -g $RESOURCE_GROUP --yes --no-wait

# Delete Kubernetes Cluster Context
kubectl config delete-context ship-manager-cluster