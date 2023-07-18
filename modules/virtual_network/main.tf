resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name
 
}

resource "azurerm_network_security_rule" "rule-01" {
  name                        = "rule-01"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}


resource "azurerm_network_security_rule" "rule-02" {
  name                        = "rule-02"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}


resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/26"
    security_group = azurerm_network_security_group.nsg.id
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/26"
    security_group = azurerm_network_security_group.nsg.id
  }

  subnet {
    name           = "subnet3"
    address_prefix = "10.0.2.0/26"
    security_group = azurerm_network_security_group.nsg.id
  }

  subnet {
    name           = "subnet4"
    address_prefix = "10.0.2.0/26"
    security_group = azurerm_network_security_group.nsg.id
  }

}