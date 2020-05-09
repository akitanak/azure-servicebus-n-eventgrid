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

resource "azurerm_servicebus_subscription" "example1" {
  name                = "example1-sevicebus-subscription"
  resource_group_name = azurerm_resource_group.example.name
  namespace_name      = azurerm_servicebus_namespace.example.name
  topic_name          = azurerm_servicebus_topic.example.name
  max_delivery_count  = 1
}

resource "azurerm_servicebus_subscription" "example2" {
  name                = "example2-sevicebus-subscription"
  resource_group_name = azurerm_resource_group.example.name
  namespace_name      = azurerm_servicebus_namespace.example.name
  topic_name          = azurerm_servicebus_topic.example.name
  max_delivery_count  = 1
}

resource "azurerm_servicebus_subscription_rule" "example2" {
  name                = "example2_sevicebus_rule"
  resource_group_name = azurerm_resource_group.example.name
  namespace_name      = azurerm_servicebus_namespace.example.name
  topic_name          = azurerm_servicebus_topic.example.name
  subscription_name   = azurerm_servicebus_subscription.example2.name
  filter_type         = "SqlFilter"
  sql_filter          = "event_type = 'join'"
}

resource "azurerm_servicebus_subscription" "example3" {
  name                = "example3-sevicebus-subscription"
  resource_group_name = azurerm_resource_group.example.name
  namespace_name      = azurerm_servicebus_namespace.example.name
  topic_name          = azurerm_servicebus_topic.example.name
  max_delivery_count  = 1
}

resource "azurerm_servicebus_subscription_rule" "example3" {
  name                = "example3_sevicebus_rule"
  resource_group_name = azurerm_resource_group.example.name
  namespace_name      = azurerm_servicebus_namespace.example.name
  topic_name          = azurerm_servicebus_topic.example.name
  subscription_name   = azurerm_servicebus_subscription.example3.name
  filter_type         = "SqlFilter"
  sql_filter          = "event_type = 'leave'"
}