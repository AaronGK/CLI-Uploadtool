output "env_file" {
  value = <<EOT
AZURE_CLIENT_ID=${azuread_application.app.application_id}
AZURE_CLIENT_SECRET=${azuread_application_password.password.value}
AZURE_TENANT_ID=${data.azurerm_client_config.current.tenant_id}
AZURE_SUBSCRIPTION_ID=${data.azurerm_client_config.current.subscription_id}
AZURE_STORAGE_ACCOUNT=${azurerm_storage_account.storage.name}
AZURE_STORAGE_CONTAINER=${azurerm_storage_container.container.name}
EOT
  sensitive = true
}
