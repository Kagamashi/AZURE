resource "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku_name            = var.sku
  tenant_id           = var.tenant_id

  access_policy {
    tenant_id = var.tenant_id #data.azurerm_client_config.current.tenant_id
    object_id = "8671eef6-d77d-4f72-94f2-ad60168c3d0a"

    key_permissions = [
      "Create",
      "Get",
      "List",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List"
    ]
  }

  tags = {
    Owner = "MikolajBorecki"
  }
}

### Variables ###

variable "key_vault_name" {
  type    = string
  default = "KV-MB-u676835" #3-24 chars, only alphanumeric characters and dashes
}

variable "sku" {
  type    = string
  default = "standard" #possible values: standard/premium
}
