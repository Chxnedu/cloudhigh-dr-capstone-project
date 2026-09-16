variable "resource_group_name" {
  description = "Name of your EXISTING resource group"
  type        = string
  default     = "DR-Readiness-CloudHigh"        # <-- e.g. "myapp-prod-rg"
}

variable "plan_name" {
  description = "Name of your EXISTING App Service Plan"
  type        = string
  default     = "ASP-DRReadinessCloudHigh-bada"      # <-- e.g. "myapp-asp"
}

variable "webapp_name" {
  description = "Name of your EXISTING Web App"
  type        = string
  default     = "payment-app"       # <-- e.g. "myapp-webapp" (must be globally unique in Azure)
}

variable "node_version" {
  description = "Node version your app runs on"
  type        = string
  default     = "24-lts"                 # <-- match whatever you're actually running
}

variable "app_command_line" {
  description = "Startup command for your Node app"
  type        = string
  default     = "npm start"
}

variable "zip_path" {
  description = "Path to your built app zip file"
  type        = string
  default     = "./recovery.zip"           # <-- CHANGE to wherever your zip actually lives
}