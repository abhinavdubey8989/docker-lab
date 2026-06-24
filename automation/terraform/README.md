# Aim
This file list the steps to use Terraform to create/delete resources from the `workstation-node`


## Terraform overview

- Terraform does not require specific filenames. It automatically loads and merges all `*.tf` files in a directory into a single configuration before execution.

- This allows flexibility in how infrastructure code is organized. However, using a consistent file structure improves readability, maintainability, and scalability.


## File Loading Behavior

- Terraform treats all .tf files in a directory as a single configuration unit:

- All files are merged internally, file names do not affect execution order, only the directory boundary matters
- All the below are combined during `terraform plan/apply`

```
main.tf
providers.tf
variables.tf
outputs.tf
```

## Recommended File Structure

- While not mandatory, the following structure is widely adopted for clarity:

```
terraform-project-dir/
│
├── main.tf          # Core infrastructure resources (EC2, VPC, SG, etc.)
├── providers.tf     # Provider configuration (AWS, GCP, etc.)
├── variables.tf     # Input variables definition
├── outputs.tf       # Output values
├── terraform.tfvars # Actual values for variables (optional)
```


## Initialize Terraform & manipulate the resources from workstation-node
1. Navigate to your Terraform project directory
2. Initialize Terraform (Downloads required provider plugins, prepares working directory for execution)
```
terraform init
```

3. Validate Configuration (Optional but recommended)
```
terraform validate
```

4. Preview Execution Plan (shows what resources will be created/modified/destroyed)
```
terraform plan
```

5. Apply Infrastructure Changes
```
terraform apply
```
Terraform will: Show execution plan again & ask for confirmation, type `yes` to confirm


6. Auto-Approve (Optional, to skip confirmation prompt)
```
terraform apply -auto-approve
```


7. View Outputs after successful deployment
```
terraform output
```


8. Destroy Infrastructure (Cleanup)
```
terraform plan -destroy
terraform destroy # type yes to confirm

or

terraform destroy -auto-approve
```