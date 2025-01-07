resource "azurerm_resource_group" "rg" {
    name = "functionapptest-rg"
    location = "australiaeast"
}

resource "azurerm_service_plan" "service_plan" {
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku_name = "EP1"
    os_type = "Windows"
    name = "ElasticPremiumPlan"
}

resource "azurerm_storage_account" "sa" {
    name = "functionapptest"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    account_tier = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_windows_function_app" "function_app" {
    name = "coadaaronswap"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    storage_account_access_key = azurerm_storage_account.sa.primary_access_key
    storage_account_name = azurerm_storage_account.sa.name
    service_plan_id = azurerm_service_plan.service_plan.id

    site_config {
      
    }
}

resource "azurerm_windows_function_app_slot" "staging" {
    name = "staging"
    function_app_id = azurerm_windows_function_app.function_app.id
    storage_account_name = azurerm_storage_account.sa.name
    storage_account_access_key = azurerm_storage_account.sa.primary_access_key

    site_config {
        application_stack {
          dotnet_version = "v8.0"
          use_dotnet_isolated_runtime = true
        }

    }
    app_settings = {
        "Test"="Hello",
        "WEBSITE_RUN_FROM_PACKAGE"="1"
    }
}

resource "azurerm_function_app_active_slot" "active" {
    count = var.swap_slots ? 1 : 0
    slot_id = azurerm_windows_function_app_slot.staging.id
}