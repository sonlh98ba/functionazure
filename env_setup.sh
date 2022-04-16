#!/bin/bash
# adopted from  https://docs.microsoft.com/cli/azure/cosmosdb
# --------------------------------------------------
#
# Create a MongoDB API database and collection
#
#

# Variables for MongoDB API resources
#uniqueId=$RANDOM
resourceGroupName="udacity"
location='eastus2'
accountName="udacityneighbourly" #needs to be lower case
serverVersion='3.6' #3.2 or 3.6
databaseName='neighborlydb'
collection1Name='advertisements'
collection2Name='posts'

# Create a resource group
az group create -n $resourceGroupName -l $location

# Create a Cosmos account for MongoDB API
az cosmosdb create \
    -n $accountName \
    -g $resourceGroupName \
    --kind MongoDB \
    --server-version $serverVersion \
    --default-consistency-level Eventual \
    --locations regionName=$location failoverPriority=0 isZoneRedundant=False 

# Create a MongoDB API database
az cosmosdb mongodb database create \
    -a $accountName \
    -g $resourceGroupName \
    -n $databaseName


# Create a MongoDB API collection
az cosmosdb mongodb collection create \
    -a $accountName \
    -g $resourceGroupName \
    -d $databaseName \
    -n $collection1Name \
    --throughput 400 \

az cosmosdb mongodb collection create \
    -a $accountName \
    -g $resourceGroupName \
    -d $databaseName \
    -n $collection2Name \
    --throughput 400 \
