provider "azurerm" {
  features {}
  version = "=2.3.0"
}

resource "azurerm_resource_group" "example" {
  name     = "servicebus-n-eventgrid"
  location = "westus2"
}

resource "azurerm_servicebus_namespace" "example" {
  name                = "example-servicebus-namespace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
}

resource "azurerm_servicebus_topic" "example" {
  name                         = "example-servicebus-topic"
  resource_group_name          = azurerm_resource_group.example.name
  namespace_name               = azurerm_servicebus_namespace.example.name
  enable_batched_operations    = true
  requires_duplicate_detection = true
  support_ordering             = true
}
