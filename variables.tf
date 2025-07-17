variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "northbay-resoucegroup"
}

variable "location" {
  description = "The Azure region to deploy resources."
  type        = string
  default     = "East US"
}

variable "aks_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster."
  type        = string
}

variable "acr_name" {
  description = "The name of the Azure Container Registry. Must be globally unique."
  type        = string
}

variable "agent_pool_vm_size" {
  description = "The size of the agent pool VM."
  type        = string
}

variable "agent_pool_node_count" {
  description = "The number of nodes per agent pool."
  type        = number
  default     = 2
}