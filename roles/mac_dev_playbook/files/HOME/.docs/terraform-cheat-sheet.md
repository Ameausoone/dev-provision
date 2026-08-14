# Terraform
## Basic workflow
```sh
terraform init
terraform plan -out=tfplan
terraform apply tfplan
terraform destroy
```

## State
```sh
terraform state list
terraform state show <resource>
terraform state rm <resource>
terraform import <resource> <id>
```

## Workspace
```sh
terraform workspace list
terraform workspace new <name>
terraform workspace select <name>
```

## Output & variables
```sh
terraform output <name>
terraform apply -var-file="prod.tfvars"
```
