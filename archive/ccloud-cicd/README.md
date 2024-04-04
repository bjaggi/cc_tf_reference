# Confluent Cloud Automation Repository
This repository consists of two sub-repositories: users-invite and terraform-scripts. These repositories provide automation for managing users and creating Confluent Cloud resources using Terraform.

## users-invite Repository
The users-invite repository contains scripts for automating the process of inviting users to Confluent Cloud and configuring RBAC authorization. It includes the following components:

- `invite-users-v2.py`: A Python script to send invitations to users and generate a JSON file containing user data.
- `convert-to-yaml.py`: A Python script to convert the user data JSON file to a tfvars YAML format, suitable for use with Terraform.
Please refer to the README file in the users-invite repository for more details on how to configure and run the scripts.

## terraform-scripts Repository
The terraform-scripts repository contains Terraform scripts for provisioning various Confluent Cloud resources. The scripts are organized into different directories, each targeting a specific resource. The available resource directories are as follows:

- `kafka-clusters`: Contains Terraform scripts to create and manage Kafka clusters in Confluent Cloud.
- `ksql-clusters`: Contains Terraform scripts to create and manage ksqlDB clusters in Confluent Cloud.
- `kafka-topics`: Contains Terraform scripts to manage Kafka topics in Confluent Cloud.
- `acls`: Contains Terraform scripts to manage ACLs (Access Control Lists) in Confluent Cloud.
- `rbac-rolebindings`: Contains Terraform scripts to manage RBAC (Role-Based Access Control) role bindings in Confluent Cloud.
- `confluent-sa`: Contains Terraform scripts to manage Confluent Service Accounts in Confluent Cloud.
- `destination-initiated-clusterlinking` and `source-initiated-clusterlinking`: Contains Terraform scripts to establish cluster linking between Confluent Cloud clusters.


## GitHub Actions Workflow Example
This repository also provides an example of a GitHub Actions workflow to run the Terraform scripts in a working directory and save the Terraform state in Azure Blob Storage. The workflow file is located in the `github-actions` directory. It includes the following steps:

1. Checkout the repository.
2. Configure Azure credentials.
3. Set up Terraform.
4. Run terraform init to initialize the Terraform environment and configure Azure Blob Storage for the tf state store.
5. Run terraform apply to create or modify the resources.
