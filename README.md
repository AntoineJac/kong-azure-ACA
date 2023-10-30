# terraform-konnect-dp

This is a Terraform script to create Kong DP in a Azure Container Apps cluster and establish connection with Konnect.

## Module Configuration Options Setup

The following fields are available for module configuration, with descriptions:

| Key     | Description | Data Type  | Default Value | Require |
| ------- | ----------- | ---------- | ------------- | ------- |
| resource_group_name | The name of the resource group where the Container App Environment will be deployed | string | null | **true** |
| container_app_environment_id | The name of the Container App Environment where the Kong DP will be deployed | string | null | **true** |
| container_registry_login_server| The Azure container registry login server | string | null | **true** |
| environment_name | The name of the Container App Environment where the Kong DP will be deployed | string | null | **true** |

### Konnect Value

The following fiels are available for Konnect configuration, with descriptions:

| Key     | Description | Data Type  | Default Value | Require |
| ------- | ----------- | ---------- | ------------- | ------- |
| konnect_external_cp_endpoint | The cluster control plane endpoint as defined in Konnect "xxxxxx.eu.cp0.konghq.com" for the external DP | string | null | **true** |
| konnect_external_telemetry_endpoint | The cluster telemetry endpoint as defined in Konnect "xxxxxx.eu.tp0.konghq.com" for the external DP | string | null | **true** |
| konnect_external_tls_crt | The TLS certificate of the Konnect external Control Plane | string | null | **true** |
| konnect_external_tls_key | The TLS key of the Konnect external Control Plane | string | null | **true** |
| konnect_internal_cp_endpoint | The cluster control plane endpoint as defined in Konnect "xxxxxx.eu.cp0.konghq.com" for the internal DP | string | null | **true** |
| konnect_internal_telemetry_endpoint | The cluster telemetry endpoint as defined in Konnect "xxxxxx.eu.tp0.konghq.com" for the internal DP | string | null | **true** |
| konnect_internal_tls_crt | The TLS certificate of the Konnect internal Control Plane | string | null | **true** |
| konnect_internal_tls_key | The TLS key of the Konnect internal Control Plane | string | null | **true** |

**Important**
Azure Container App is expecting the certificate to be passed as a string. You can use the following command to convert a certificate into a string:
```
awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' tls.crt

awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' tls.key
```

### Kong Data Plane Value

Please use your own data plane values using  Kong Configuration documentation: https://docs.konghq.com/gateway/latest/reference/configuration/

| Key     | Description | Data Type  | Default Value | Require |
| ------- | ----------- | ---------- | ------------- | ------- |
| kong_container_image_repo | The repository for the image of the Kong Data Plane | string | null | **true** |
| kong_container_image_tag | The container image of the Kong Data Plane | string | null | **true** |
| kong_container_image_tag_traffic | The container image of the Kong Data Plane receving production traffic | string | null | **true** |
| kong_container_max_replicas | The max replicas of the Kong Data Plane | number | null | **true** |
| kong_container_nginx_worker_processes | The number of worker processes of the Kong Data Plane | number | null | **true** |
| kong_container_cpu | The CPU of the Kong Container Data Plane | number | null | **true** |
| kong_container_memory | The memory of the Kong Container Data Plane | string | null | **true** |

### Provider

The default providers is using local context. You can also use your own confiy by declaring them in the azurerm provider

- **subscription_id**: the Azure subscription ID
- **client_id**: the  Azure Active Directory (AAD) application client ID
- **client_secret**: the Azure AD application client secret
- **tenant_id**: the Azure AD tenant ID

```
provider "azurerm" {
  features {}
  
  # Authentication settings
  subscription_id = "your-subscription-id"
  client_id       = "your-client-id"
  client_secret   = "your-client-secret"
  tenant_id       = "your-tenant-id"
}
```

**IMPORTANT**
Before you use Azure Storage as a backend, you must create a storage account. 
Run the following commands or configuration to create an Azure storage account and container:

```
resource "azurerm_storage_account" "tfstate" {
  name                     = "konnectaca"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    env = "environment name"
    role = "external or internal"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "konnect-tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
```

You can then use as terrform backend:
```
backend "azurerm" {
    resource_group_name  = "XXXXX"
    storage_account_name = "konnectaca"
    container_name       = "konnect-tfstate"
    key                  = "konnect-terraform-test.tfstate"
}
```
## Terraform Deployment

You can either use Azure Pipeline action or use following command line:
- **terraform init**: the terraform init command initializes a working directory containing Terraform configuration files.

- **terraform plan -var-file=values.tfvars**: the terraform plan command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.

- **terraform apply -var-file=values.tfvars**: the terraform apply command executes the actions proposed in a Terraform plan to create, update, or destroy infrastructure.

- **terraform destroy -var-file=values.tfvars**: the terraform destroy command executes the actions proposed in a Terraform plan to destroy infrastructure.

