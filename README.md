# Web App for Containers + Azure Registry deployment

A single ARM template that deploys an Azure Container Registry (ACR), imports an image from Docker Hub, and deploys a Web App for Containers using the image.

The template uses Azure Container Instances (ACI) to run an ephemeral container to execute the necessary `az` commands. ACI is configured to use a Managed Service Identity (MSI) and is given a Contributor role to the current Resource Group, so that `az` can be authorized to run the appropriate commands.

