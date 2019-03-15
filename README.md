# Web App for Containers + Azure Registry deployment

A single ARM template that deploys an Azure Container Registry (ACR), imports an image from Docker Hub, and deploys a Web App for Containers using the image.

The template uses Azure Container Instances (ACI) to run an ephemeral container to execute the necessary `az` commands. ACI is configured to use a Managed Service Identity (MSI) and is given a Contributor role to the current Resource Group, so that `az` can be authorized to run the appropriate commands.

## Usage

The included `test.sh` script shows how to run the deployment using the `az` command line.

## How it works

Since ARM templates do not allow comments, here are some details about how it works.

- The main template will call the `acr.json` nested template to create an ACR instance. 
- The `acr.json` template outputs the credentials for the registry (login server, user, password); these credentials will be used later to configure the Web App.
- The main template then calls `aci.json` to create an ACI instance and request a system-assigned managed identity. The generated service principal is captured in the outputs.
    - The MSI is assigned by adding `"identity": {"type": "SystemAssigned"}` to the `containerGroups` resource.
- The Contributor role is then assigned to the service principal, using a `roleAssignments` resource.
- The `aci-import.json` nested template is then called to update the ACI resource and add a container to run; this ephemeral container uses the Microsoft `az` image in Docker Hub to run an `az acr import` command.
    - The command that is run is basically: `( sleep 5 ; az login --identity ; az acr import --name myacrname --source docker.io/library/nginx:latest --image nginx:latest )`
- Now that we have an ACR and that we have imported an image, we are ready to finally deploy the Web App.
- The Web App is configured to run on Linux and run a Docker image. The template points the Web App to the newly created container registry, using the credentials retrieved above.

## Disclaimer

This is just a sample. Use it at your own risk!
