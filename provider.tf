terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.36.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "df6d8ac0-ca9e-4233-bd5c-bd67b696c525"
}