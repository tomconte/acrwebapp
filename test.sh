#!/bin/bash

echo "START DEPLOYMENT"
date

az group create --name acrwebapp --location westeurope
az group deployment create --resource-group acrwebapp --template-uri https://raw.githubusercontent.com/tomconte/acrwebapp/master/azuredeploy.json --parameters siteName=acrwebapptest

while true
do
  curl http://acrwebapptest.azurewebsites.net/
  if [ $? -eq 0 ]
  then
    break
  fi
  sleep 3
  echo "Retrying curl..."
done

echo "SUCCESS!"
date

az group delete --name acrwebapp --yes
