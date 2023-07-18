

data "azurerm_client_config" "current" {}


locals {
  current_user_id = coalesce(var.msi_id, data.azurerm_client_config.current.object_id)
}

resource "azurerm_key_vault" "vault" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = local.current_user_id

    key_permissions    = var.key_permissions
    secret_permissions = var.secret_permissions
  }
}


resource "azurerm_key_vault_key" "key" {
  name = var.key_vault_name
  key_vault_id = azurerm_key_vault.vault.id
  key_type     = var.key_type
  key_size     = var.key_size
  key_opts     = var.key_ops

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}
data "azurerm_subnet" "subnet1"{
  name = var.subnet1_name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.virtual_network_name
}
resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${var.key_vault_name}-pe1"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.subnet1.id

  private_service_connection {
    name                           = "${var.key_vault_name}-private-service"
    is_manual_connection           = false
    private_connection_resource_id = "${var.key_vault_name}id"
    subresource_names              = ["key_vault"]
  }
}