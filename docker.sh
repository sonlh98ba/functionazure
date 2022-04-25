uniqueId=20220424
resourceGroup="group$uniqueId"
location='australiaeast'
account="cosmos$uniqueId"
serverVersion='3.6'
database="mongodb$uniqueId"
adCollection="adcollection$uniqueId"
postCollection="postcollection$uniqueId"
storageAccount="blob$uniqueId" 
funcApp="funcapp$uniqueId"
appRegistry="appregistry$uniqueId"
kuberCluster="kubercluster$uniqueId"
docker="docker$uniqueId"

# Create a Container Registry
az acr create \
    --resource-group $resourceGroup \
    --name $appRegistry \
    --sku Basic

az acr login --name $appRegistry

az acr show \
    --name $appRegistry \
    --query loginServer \
    --output table

TOKEN=$(az acr login --name $appRegistry --expose-token --output tsv --query accessToken)

# Login to the registry
docker login $appRegistry.azurecr.io \
    --username 00000000-0000-0000-0000-000000000000 \
    --password $TOKEN

# Containerize the App
func init --docker-only --python

# Build the docker image
docker build -t $docker .

docker run -p 8080:80 -it $docker

docker tag $docker $appRegistry.azurecr.io/$docker:v1
docker images

# Push the image to Azure Container Registry
docker push $appRegistry.azurecr.io/$docker:v1

# check if the docker image is up in the cloud.
az acr repository list \
--name $appRegistry.azurecr.io \
--output table

# Create a Kubernetes Cluster
# Create a Kubernetes cluster on Azure
az aks create \
    --resource-group $resourceGroup \
    --name $kuberCluster \
    --node-count 2 \
    --generate-ssh-keys

az aks get-credentials \
    --name $kuberCluster \
    --resource-group $resourceGroup

# Check the connection
kubectl get nodes

# Deploy the App to Kubernetes
func kubernetes install \
    --namespace keda  

func kubernetes deploy \
--name $kuberCluster \
--image-name $appRegistry.azurecr.io/$docker:v1 \
--dry-run \
> deploy.yml

func kubernetes deploy \
--name $kuberCluster \
--image-name $appRegistry.azurecr.io/$docker:v1 \
—polling-interval 3 \
—cooldown-period 5

kubectl apply -f deploy.yml

# Check results
kubectl config get-contexts

kubectl get service --watch

