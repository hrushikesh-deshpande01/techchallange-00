
resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

locals {
  password = random_password.password.result
}

resource "null_resource" "configure-delegation" {
  provisioner "local-exec" {
    command = "az network vnet subnet update  --resource-group $RG  --name $SUBNET --vnet-name $VNET    --delegations Microsoft.Sql/managedInstances"
    interpreter = ["PowerShell", "-Command"]
    environment = {
      RG = var.resource_group_name
      VNET = var.virtual_network_name
      SUBNET = var.subnet2_name
    }
  }
}


data "azurerm_subnet" "subnet1"{
  name = var.subnet1_name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.virtual_network_name
}

data "azurerm_subnet" "subnet2"{
  name = var.subnet2_name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.virtual_network_name
}


resource "azurerm_route_table" "route_table" {
  name                          = var.route_table_name
  location                      =  var.location
  resource_group_name           =  var.resource_group_name
  disable_bgp_route_propagation = false
}

# Associate subnet and the route table
resource "azurerm_subnet_route_table_association" "subnet_route_table_association" {
  subnet_id      = data.azurerm_subnet.subnet2
  route_table_id = azurerm_route_table.route_table.id
}

# Create managed instance
resource "azurerm_mssql_managed_instance" "main" {
  name                         = var.mssql_managed_instance_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  subnet_id                    = data.azurerm_subnet.subnet2.id
  administrator_login          = "admin123"
  administrator_login_password = local.password
  license_type                 = var.license_type
  sku_name                     = var.sku_name
  vcores                       = var.vcores
  storage_size_in_gb           = var.storage_size_in_gb
    identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${var.mssql_managed_instance_name}-pe1"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.subnet1.id

  private_service_connection {
    name                           = "${var.mssql_managed_instance_name}-private-service"
    is_manual_connection           = false
    private_connection_resource_id = "${var.mssql_managed_instance_name}id"
    subresource_names              = ["mssql_managed_instance"]
  }
}


data "azurerm_key_vault" "key_vault"{
  name                        = var.key_vault_name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id = azurerm_mssql_managed_instance.main.identity[0].tenant_id
  object_id = azurerm_mssql_managed_instance.main.identity[0].principal_id
  secret_permissions = ["Delete", "Get", "List", "Set"]

  }


  resource "azurerm_key_vault_secret" "mysql_secret" {
  name = "admin123"
  value = local.password
  key_vault_id = data.azurerm_key_vault.key_vault.id
}