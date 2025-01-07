To use:
 - Run terraform apply with swap_slots=false
 - Deploy the FunctionApp to the Staging slot
 - Run tests
 - Run terraform apply with swap_slots=true

 When running with swap_slots=false, the azurerm_function_app_active_slot resource is deleted. This appears to be the only way to trigger the slot swap to consistently occur as required. Though changes to the staging slot may trigger the swap (haven't tested).