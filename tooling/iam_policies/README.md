# CI/CD IAM Policies

This directory contains least-privilege IAM policies required for Terraform CI/CD deployments. Each policy file corresponds to the AWS permissions needed for managing specific infrastructure modules.

## Policy Files

| File | Purpose |
|------|---------|
| `acm.json` | ACM certificate management (request, validate, delete) |
| `alb.json` | Application Load Balancer, target groups, listeners |
| `ecs.json` | ECS clusters, task definitions, services, CloudWatch logs |
| `iam.json` | IAM roles, policies, instance profiles for ECS |
| `network.json` | VPC, subnets, security groups, route tables, internet gateways |
| `s3.json` | S3 access for Terraform state backend |
| `ssm.json` | SSM Parameter Store (read ECS-optimized AMI parameter) |
| `waf.json` | WAFv2 Web ACL and rule management |

## Usage

Use the setup script to create and attach all policies to an IAM user or role:

```bash
# For GitHub Actions (OIDC role)
./tooling/setup_cicd_iam.sh --type role --name github-actions-terraform

# For local development (IAM user)
./tooling/setup_cicd_iam.sh --type user --name terraform-deployer
```

The script will:
1. Create a policy for each JSON file with name `<entity-name>-<policy-name>` (e.g., `github-actions-terraform-ecs`)
2. Attach all policies to the specified IAM user or role

## Policy Details

### acm.json
Permissions to manage SSL/TLS certificates:
- Request and delete certificates
- Describe certificates and tags
- Manage certificate options

### alb.json
Permissions for load balancer infrastructure:
- Create/modify/delete load balancers, target groups, listeners
- Manage listener rules and certificates
- Describe load balancer resources

### ecs.json
Permissions for ECS container orchestration:
- Manage ECS clusters, task definitions, and services
- Create/delete CloudWatch log groups for `/ecs/*` prefix
- Pass task execution and task roles to ECS

### iam.json
Permissions for IAM resource management:
- Create/delete/update IAM roles and policies
- Manage instance profiles for EC2-backed ECS
- Attach/detach managed policies
- Scoped to resources matching the project naming pattern

### network.json
Permissions for VPC networking:
- Manage VPCs, subnets, route tables
- Create/configure security groups
- Manage internet gateways
- EC2 tagging operations

### s3.json
Permissions for Terraform state:
- List and read/write to state bucket
- Scoped to `terraform-state-*` bucket prefix

### ssm.json
Permissions for SSM Parameter Store:
- Read ECS-optimized AMI parameter (`/aws/service/ecs/optimized-ami/*`)
- Required for automatic AMI lookup in launch templates

### waf.json
Permissions for Web Application Firewall:
- Create/update/delete Web ACLs
- Associate WAF with ALB
- Manage rule groups and IP sets

## Security Considerations

- All policies follow **least-privilege** principles
- Resource ARNs are scoped where possible (e.g., `/ecs/*` log groups)
- IAM permissions include conditions (e.g., `iam:PassedToService`)
- `s3.json` should be customized to match your actual state bucket name
