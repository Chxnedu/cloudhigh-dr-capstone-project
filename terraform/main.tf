terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_service_plan" "plan" {
  name                = var.plan_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_linux_web_app" "app" {
  name                = var.webapp_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_service_plan.plan.location
  service_plan_id     = data.azurerm_service_plan.plan.id

  site_config {
    application_stack {
      node_version = var.node_version    # <-- was python_version before
    }
    app_command_line = var.app_command_line
  }

  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    WEBSITE_NODE_DEFAULT_VERSION   = var.node_version
  }
}

resource "null_resource" "deploy" {
  triggers = {
    zip_hash = filemd5(var.zip_path)
  }

  provisioner "local-exec" {
    command = "az webapp deploy --resource-group ${data.azurerm_resource_group.rg.name} --name ${azurerm_linux_web_app.app.name} --src-path ${var.zip_path} --type zip"
  }

  depends_on = [azurerm_linux_web_app.app]
}

resource "azurerm_linux_web_app_slot" "recovery" {
  name           = "recovery"
  app_service_id = azurerm_linux_web_app.app.id

  site_config {
    application_stack {
      node_version = var.node_version
    }
    app_command_line = var.app_command_line
  }

  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    WEBSITE_NODE_DEFAULT_VERSION   = var.node_version
  }
}

resource "null_resource" "deploy_recovery" {
  triggers = {
    zip_hash = filemd5(var.zip_path)
  }

  provisioner "local-exec" {
    command = "az webapp deploy --resource-group ${data.azurerm_resource_group.rg.name} --name ${azurerm_linux_web_app.app.name} --slot recovery --src-path ${var.zip_path} --type zip"
  }

  depends_on = [azurerm_linux_web_app_slot.recovery]
}