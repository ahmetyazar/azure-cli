#! /usr/bin/sh

# Create random string
guid=$(cat /proc/sys/kernel/random/uuid)
suffix=${guid//[-]/}
suffix=${suffix:0:18}

# Set the necessary variables
RESOURCE_GROUP="rg-dp100-l${suffix}"
RESOURCE_PROVIDER="Microsoft.MachineLearning"
REGIONS=("eastus" "westus")
RANDOM_REGION=${REGIONS[$RANDOM % ${#REGIONS[@]}]}
WORKSPACE_NAME="mlw-dp100-l${suffix}"
COMPUTE_INSTANCE="ci${suffix}"
COMPUTE_CLUSTER="amlcluster"

# Register the Azure Machine Learning resource provider in the subscription
echo "Register the Machine Learning resource provider:"
az provider register --namespace $RESOURCE_PROVIDER

# Create the resource group and workspace and set to default
echo "Create a resource group and set as default:"
az group create --name $RESOURCE_GROUP --location $RANDOM_REGION
az configure --defaults group=$RESOURCE_GROUP

echo "Create an Azure Machine Learning workspace:"
az ml workspace create --name $WORKSPACE_NAME 
az configure --defaults workspace=$WORKSPACE_NAME 

# Create compute instance
echo "Creating a compute instance with name: " $COMPUTE_INSTANCE
#az ml compute create --name ${COMPUTE_INSTANCE} --size STANDARD_DS11_V2 --type ComputeInstance 
#az ml compute create --name ${COMPUTE_INSTANCE} --size STANDARD_DS11_V2 --type ComputeInstance

# Create compute cluster
echo "Creating a compute cluster with name: " $COMPUTE_CLUSTER
az ml compute create --name ${COMPUTE_CLUSTER} --size STANDARD_DS11_V2 --max-instances 2 --type AmlCompute 

# Create data assets
# echo "Create training data asset:"
# az ml data create --type uri_folder --name diabetes-dev-folder --path  ./experimentation/data/

# install the Azure Machine Learning extension.
# echo "Install the Azure Machine Learning extension"
# az extension add -n ml -y

# create scikit-learn environment
az ml environment create --file "docker-conda-env.yml"

# create data asset 
# az ml data create --type uri_file --name "diabetes-csv" --path  "./data/diabetes.csv"
# az ml data create --file data-localpath.yml

# submit an Azure Machine Learning job
# echo "Submit job"
# az ml job create --file ./src/job.yml

# create service principal
# az ad sp create-for-rbac --name "sp-yazar1" --role contributor  --scopes /subscriptions/d4ada6b9-9bf9-4076-b7ec-3ab76d1b0cf8/resourceGroups/rg-dp100-l91c18a722d864a2188                               --sdk-auth



# After all the resources are created, launch ML Studio, open the terminal of the compute instance and type:
# pip uninstall azure-ai-ml
# pip install azure-ai-ml
