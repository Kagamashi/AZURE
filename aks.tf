data "azurerm_key_vault" "admin_key_vault" {
  name                = "KV-MB-u676835"
  resource_group_name = azurerm_resource_group.rg.name
}

data "azurerm_key_vault_secret" "aks_admin_username" {
  name         = "AKS-ADMIN-USERNAME"
  key_vault_id = data.azurerm_key_vault.admin_key_vault.id
}

data "azurerm_key_vault_secret" "aks_admin_ssh_pub" {
  name         = "AKS-ADMIN-SSH-PUBLIC"
  key_vault_id = data.azurerm_key_vault.admin_key_vault.id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                 = "AKS-MB-u767835"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  node_resource_group  = "RG_MB_u767835_AKS" #azurerm_resource_group.aks.name
  dns_prefix           = "my-aks-cluster"
  azure_policy_enabled = true

  default_node_pool {
    name       = "system0"
    vm_size    = var.vm_size
    node_count = 1
  }

  linux_profile {
    admin_username = data.azurerm_key_vault_secret.aks_admin_username.value

    ssh_key {
      key_data = base64decode(data.azurerm_key_vault_secret.aks_admin_ssh_pub.value)
    }
  }

  network_profile {
    network_plugin    = var.network_plugin
    load_balancer_sku = var.load_balancer_sku
  }

  dynamic "identity" {
    for_each = var.identity_type == "UserAssigned" ? [1] : []

    content {
      type         = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.aks[0].id]
    }
  }

  depends_on = [
    azurerm_user_assigned_identity.aks,
  ]

  tags = {
    Owner = "MikolajBorecki"
  }
}

### Variables ###

variable "network_plugin" {
  type    = string
  default = "kubenet"
}

variable "load_balancer_sku" {
  type    = string
  default = "standard"
}

variable "vm_size" {
  type    = string
  default = "Standard_D2_v2"
}
