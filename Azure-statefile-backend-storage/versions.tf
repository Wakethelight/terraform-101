terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.28.0"
    }
    random = {
        source  = "hashicorp/random"
        version = "~>3.7.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "bb8f3354-1ce0-4efc-b2a7-8506304c5362"
}