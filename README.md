# Introduction 
TODO: Give a short introduction of your project. Let this section explain the objectives or the motivation behind this project. 

# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references

# Build and Test
TODO: Describe and show how to build your code and run the tests. 

# Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore)

# Azure Kubernetes Service (AKS) & Azure Container Registry (ACR) Terraform Module

## Overview
This module deploys an Azure Kubernetes Service (AKS) cluster with 1 master and 2 worker nodes, and a public Azure Container Registry (ACR) for educational purposes.

## Usage
```hcl
module "aks_acr" {
  source              = "./terraform-module"
  resource_group_name = "my-aks-rg"
  location            = "East US"
  aks_name            = "myakscluster"
  dns_prefix          = "myaksdns"
  acr_name            = "myuniqueregistryname"
}
```

## Backend Setup (Azure Storage Account)
To store Terraform state in Azure, create a storage account and container:

1. Create a resource group:
   ```sh
   az group create --name tfstate-rg --location "East US"
   ```
2. Create a storage account:
   ```sh
   az storage account create --name <storage_account_name> --resource-group tfstate-rg --location "East US" --sku Standard_LRS
   ```
3. Create a storage container:
   ```sh
   az storage container create --name tfstate --account-name <storage_account_name>
   ```
4. Add the following backend block to your Terraform configuration:
   ```hcl
   terraform {
     backend "azurerm" {
       resource_group_name  = "tfstate-rg"
       storage_account_name = "<storage_account_name>"
       container_name       = "tfstate"
       key                  = "terraform.tfstate"
     }
   }
   ```

## Authentication for Terraform
- Use the Azure CLI to authenticate:
  ```sh
  az login
  ```
- Or use a Service Principal:
  ```sh
  az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
  export ARM_CLIENT_ID=...
  export ARM_CLIENT_SECRET=...
  export ARM_SUBSCRIPTION_ID=...
  export ARM_TENANT_ID=...
  ```

## Apply the Module
```sh
terraform init
terraform plan
terraform apply
```