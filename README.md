# Node.js App Deployment on Google Cloud with Terraform & PowerShell

This project deploys a Node.js web application to **Google App Engine** and provisions all necessary cloud resources using **Terraform Infrastructure as Code (IaC)**.

---

## Infrastructure as Code (IaC) with Terraform

### What It Provisions

The Terraform configuration sets up:

- A **custom service account** for the app
- A **Cloud SQL (MySQL)** instance and database
- A **Google Cloud Storage (GCS)** bucket
- **IAM roles** for App Engine, SQL, and Storage access
- An **App Engine application** for hosting the Node.js app

---

### Files Overview

- `terrform/main.tf`: core infrastructure setup
- `terrform/variables.tf`: user-defined config like project ID, region, DB credentials
- `terrform/outputs.tf`: helpful links and connection info
- `deploy.ps1`: PowerShell script to initialize the SQL tables and deploy the app

---

## How to Use the Terraform IaC

### 1. Install Requirements

- [Terraform](https://www.terraform.io/downloads)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- A GCP Project with billing enabled

### 2. Initialize and apply Terraform
```bash
cd terraform
terraform init
terraform apply
```

### How to Run the Deployment Script (deploy.ps1)
The PowerShell script performs two actions:

1. Initializes the Cloud SQL database:
    - Connects using the MySQL CLI
    - Runs init.sql to create users and items tables 
    - Inserts an admin user (admin / admin123) if it doesn’t exist
2. Deploys the Node.js app to App Engine using gcloud app deploy

To Run the Script
- Open PowerShell in the project root and run:

```powershell
.\deploy.ps1
```
Make sure: mysql.exe is in your system PATH

### Final App URL
After deployment, the app will be available at:

```arduino
https://final-459618.appspot.com
```
(You can also check the output from terraform apply.)

