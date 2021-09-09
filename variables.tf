variable "rgname" {
  type = string
  default = "cosmosdblearn-rg"
}

variable "rglocation" {
  type = string
  default = "australiaeast"
}

variable "cosmosdbaccountname" {
  type = string
  default = "velidatutorialcosmosdb"
}

variable "cosmosdbname" {
  type = string
  default = "DemoDB"
}

variable "cosmosdbcontainer" {
  type = string
  default = "DemoContainer"
}

variable "loganalyticsname" {
  type = string
  default = "velidaloganalytics"
}

variable "loganalytics_resource_group_name" {
  type = string
  default = "velidaazureengine-rg"
}

variable "cosmos_log_settings_name" {
  type = string
  default = "cosmoslogsettings"
}