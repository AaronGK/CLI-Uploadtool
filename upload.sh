#!/usr/bin/env bash

# -----------------------------------------------------------------
# Script: upload_to_azure.sh
# Purpose: Upload files to Azure Storage using a Service Principal.
# -----------------------------------------------------------------

# === Load Environment Variables ===================================
load_env_vars() {
  if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    export $(grep -v '^#' .env | xargs)
  else
    echo "Warning: .env file not found. Ensure all variables are set."
  fi
}

# === Validate Required Environment Variables ======================
validate_env_vars() {
  REQUIRED_VARS=(
    "AZURE_CLIENT_ID"
    "AZURE_CLIENT_SECRET"
    "AZURE_TENANT_ID"
    "AZURE_SUBSCRIPTION_ID"
    "AZURE_STORAGE_ACCOUNT"
    "AZURE_STORAGE_CONTAINER"
  )

  for VAR in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!VAR}" ]; then
      echo "Error: Missing required environment variable: $VAR"
      echo "Check your .env file or set the variable manually."
      exit 1
    fi
  done
}

# === Authenticate with Azure ======================================
authenticate_with_azure() {
  echo "Authenticating with Azure..."
  az login --service-principal \
    --username "$AZURE_CLIENT_ID" \
    --password "$AZURE_CLIENT_SECRET" \
    --tenant "$AZURE_TENANT_ID" 1>/dev/null

  az account set --subscription "$AZURE_SUBSCRIPTION_ID"
  echo "Azure authentication successful."
}

# === Upload File to Azure Storage =================================
upload_file() {
  local file_path="$1"

  # Check if file exists
  if [ ! -f "$file_path" ]; then
    echo "Error: File '$file_path' does not exist."
    return 1
  fi

  local file_name
  file_name=$(basename "$file_path")

  echo "Uploading '$file_path' to Azure Storage container '$AZURE_STORAGE_CONTAINER'..."
  az storage blob upload \
    --account-name "$AZURE_STORAGE_ACCOUNT" \
    --container-name "$AZURE_STORAGE_CONTAINER" \
    --name "$file_name" \
    --file "$file_path" \
    --auth-mode login

  echo "Upload successful: $file_name"
}

# === Main Script Logic ============================================
main() {
  # Load environment variables
  load_env_vars

  # Validate required variables
  validate_env_vars

  # Authenticate with Azure
  authenticate_with_azure

  # Check if file paths are provided as arguments
  if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_path> [<file_path> ...]"
    exit 1
  fi

  # Process each file path and upload
  for file_path in "$@"; do
    upload_file "$file_path"
  done

  # Explicitly log out from Azure
  echo "Logging out from Azure..."
  az logout
  echo "Azure session terminated."
}

# === Execute Main Function ========================================
main "$@"
