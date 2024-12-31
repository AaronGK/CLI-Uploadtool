## CLI-Uploadtool Overview

The CLI-Uploadtool simplifies file uploads to Azure, specifically when using a service principal for authentication. 

It includes:

**Terraform Configurations:** Automatically creates Azure Storage resources and a service principal using your current Azure CLI login session.

**Upload Script (upload.sh):** Leverages storage details from a `.env` file to manage file uploads. 

You can use these components together—Terraform to provision and configure the storage and service principal, followed by `upload.sh` for uploading files.

If you choose not to use the Terraform configurations, you can still use the `upload.sh` script. However, you must manually provide your service principal and storage account details.

---

## Prerequisites

- **Azure CLI** installed and authenticated.  
  - [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)  
  - [Sign in with Azure CLI](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
- (Optional) **Terraform** if you plan to use the included Terraform setup.  
  - [Install Terraform](https://www.terraform.io/downloads.html)
- **Bash** shell (for running `upload.sh`).

---

## Terraform Setup

The Terraform configuration automates the setup process by:
- Creating an Azure Storage Account and Blob Container.
- Generating a **service principal** with storage permissions to ensure you don’t need to log in with `az login` every time you use the tool.

1. **Authenticate with Azure CLI**  

   Make sure you are logged into the correct subscription:
   ```bash
   az login
   az account set --subscription "YOUR_SUBSCRIPTION_ID"

2. **Navigate to the Terraform directory**

   ```bash
   cd terraform

3. **Configure variables**
   
   Copy the provided `example.tfvars` file to `terraform.tfvars`:
   ```bash
   cp example.tfvars terraform.tfvars
   ```
   Update the `terraform.tfvars` file with your specific values.
  
4. **Initialize and apply Terraform**

   ```bash
   terraform init
   terraform plan -var-file="terraform.tfvars"
   terraform apply -var-file="terraform.tfvars"

5. **Collect output**

   Terraform then outputs newly created resource information (like Storage Account Name, Container Name, Keys, etc.) to the `.env` file in the project root so the `upload.sh` script knows how to interact with your storage account.

   An example `.env` file might look like this:

   ```bash
   AZURE_CLIENT_ID=example_client_id
   AZURE_CLIENT_SECRET=example_client_secret
   AZURE_TENANT_ID=example_tenant_id
   AZURE_SUBSCRIPTION_ID=example_subscription_id
   AZURE_STORAGE_ACCOUNT=aexample_sa_name
   AZURE_STORAGE_CONTAINER=example_sc_name
   ```

6. **Persistent Access**
   
   The service principal allows `upload.sh` to authenticate directly with Azure Storage without requiring `az login`. This ensures a seamless experience for file uploads.

---

## Manual Setup

If you already have an Azure Storage account and container—or you just prefer not to use Terraform—simply:

1. **Configure .env**

   Copy the provided `example.env` file to `.env`:
   ```bash
   cp example.env .env
   ```
   Update the `.env` file with your specific values.

   An example `.env` file might look like this:

   ```bash
   AZURE_CLIENT_ID=example_client_id
   AZURE_CLIENT_SECRET=example_client_secret
   AZURE_TENANT_ID=example_tenant_id
   AZURE_SUBSCRIPTION_ID=example_subscription_id
   AZURE_STORAGE_ACCOUNT=aexample_sa_name
   AZURE_STORAGE_CONTAINER=example_sc_name
   ```

## Using the CLI Upload tool

Once the `.env` file is filled out (either from Terraform outputs or your own values), you can upload files with:

   ```bash
   ./upload.sh path/to/local/file.txt
   ```

**What happens:**

1. upload.sh loads variables from `.env`.
2. It uses az storage blob upload to upload your file into the specified container.

You can also pass multiple files:

   ```bash
   ./upload.sh file1.txt file2.pdf file3.jpg
   ```

## Project Structure

```
CLI-Uploadtool/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── example.tfvars
│   └── terraform.tfvars (optional - user-defined)
├── upload.sh
├── .env (generated or manually created)
└── README.md
```

- terraform/ contains the Terraform configuration files.
- example.tfvars is a template file for users to create their own terraform.tfvars.
- upload.sh is the Bash script for uploading files.
- .env holds the environment variables used by upload.sh (auto-populated by Terraform outputs or manually created).