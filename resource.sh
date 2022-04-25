# Variables for MongoDB API resources
uniqueId=20220424
resourceGroup="group$uniqueId"
location='australiaeast'
account="cosmos$uniqueId" #needs to be lower case
serverVersion='3.6' #3.2 or 3.6
database="mongodb$uniqueId"
adCollection="adcollection$uniqueId"
postCollection="postcollection$uniqueId"
storageAccount="blob$uniqueId"
funcApp="funcapp$uniqueId"
# Create a resource group
az group create -n $resourceGroup -l $location
# Create a Cosmos account for MongoDB API
az cosmosdb create -n $account -g $resourceGroup --kind MongoDB --server-version $serverVersion --default-consistency-level Eventual --locations regionName='Australia East' failoverPriority=0 isZoneRedundant=False
# Create a MongoDB API database
az cosmosdb mongodb database create -a $account -g $resourceGroup -n $database
# Create a MongoDB API collection
az cosmosdb mongodb collection create -a $account -g $resourceGroup -d $database -n $adCollection --throughput 400
az cosmosdb mongodb collection create -a $account -g $resourceGroup -d $database -n $postCollection --throughput 400
# Create a storage account
az storage account create --name $storageAccount --resource-group $resourceGroup --location $location
# Creat a function app
az functionapp create --resource-group $resourceGroup --name $funcApp --storage-account $storageAccount --os-type Linux --consumption-plan-location $location --runtime python