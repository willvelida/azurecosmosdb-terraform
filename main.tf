terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 2.65"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = var.rgname
  location = "australiaeast"
}

data "azurerm_log_analytics_workspace" "loganalytics" {
  name = var.loganalyticsname
  resource_group_name = var.loganalytics_resource_group_name
}

resource "azurerm_cosmosdb_account" "db" {
  name = "velidatutorialcosmosdb"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type = "Standard"
  kind = "GlobalDocumentDB"

  consistency_policy {
      consistency_level = "Session"
  }

  geo_location {
    location = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "db" {
  name = var.cosmosdbname
  resource_group_name = azurerm_resource_group.rg.name
  account_name = azurerm_cosmosdb_account.db.name
}

resource "azurerm_cosmosdb_sql_container" "container" {
  name = var.cosmosdbcontainer
  resource_group_name = azurerm_resource_group.rg.name
  account_name = azurerm_cosmosdb_account.db.name
  database_name = azurerm_cosmosdb_sql_database.db.name
  partition_key_path = "/id"
  throughput = 400
}

resource "azurerm_monitor_diagnostic_setting" "cosmosdbdiagnostic" {
  name = var.cosmos_log_settings_name
  target_resource_id = azurerm_cosmosdb_account.db.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.loganalytics.id

  log {
    category = "DataPlaneRequests"
    enabled = true
  }

  log {
    category = "QueryRuntimeStatistics"
    enabled = true
  }

  log {
    category = "PartitionKeyStatistics"
    enabled = true
  }

  log {
    category = "PartitionKeyRUConsumption"
    enabled = true
  }

  log {
    category = "ControlPlaneRequests"
    enabled = true
  }
}