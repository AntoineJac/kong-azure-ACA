terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0"
    }
    # Add other required providers if needed
  }

  backend "azurerm" {
      resource_group_name  = "XXXXXX"
      storage_account_name = "konnectaca"
      container_name       = "konnect-tfstate"
      key                  = "konnect-terraform-test.tfstate"
  }

}
