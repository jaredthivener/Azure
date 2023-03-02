#!/bin/bash

# Login to Azure
az login

# Set the subscription to work with
az account set --subscription <insert subscription id>

# Get a list of all the available resource providers
providers=$(az provider list --query [*].namespace --output tsv)

# Loop through the list of resource providers and register each one
for provider in $providers
do
  echo "Registering $provider"
  az provider register --namespace $provider
done
