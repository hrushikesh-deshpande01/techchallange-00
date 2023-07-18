resource "null_resource" "configure-delegation" {
  provisioner "local-exec" {
    command = "az network vnet subnet update  --resource-group $RG  --name $SUBNET --vnet-name $VNET    --delegations Microsoft.Web/serverFarms"
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

resource "azurerm_service_plan" "service_plan" {
  name                = var.service_plan
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "linux_web_app" {
  name                = var.linux_web_app
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.service_plan.id
  https_only          = true
  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on        = true
    app_command_line = var.app_command_line
    application_stack {
      java_version =var.java_version
      java_server_version =var.java_server_version
      java_server =var.java_server
      node_version = var.node_version
      php_version = var.php_version
      go_version = var.go_version
      python_version = var.python_version
    }
  }
}


data "azurerm_key_vault" "key_vault"{
  name                        = var.key_vault_name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id = azurerm_linux_web_app.linux_web_app.identity[0].tenant_id
  object_id = azurerm_linux_web_app.linux_web_app.identity[0].principal_id
  secret_permissions = ["Delete", "Get", "List", "Set"]

  }

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_virtual_network_swift_connection" {
  app_service_id = azurerm_linux_web_app.linux_web_app.id
  subnet_id      = data.azurerm_subnet.subnet1.id
}
resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${var.service_plan}-${var.linux_web_app}-pe1"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.subnet1.id

  private_service_connection {
    name                           = "${var.service_plan}-${var.linux_web_app}-private-service"
    is_manual_connection           = false
    private_connection_resource_id = "${var.service_plan}${var.linux_web_app}id"
    subresource_names              = ["linux_web_app"]
  }
}