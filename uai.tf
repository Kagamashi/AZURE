resource "azurerm_user_assigned_identity" "aks" {
  count = var.identity_type == "UserAssigned" ? 1 : 0

  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = "UAI-AKS-MB"

  tags = {
    Owner = "MikolajBorecki"
  }
}