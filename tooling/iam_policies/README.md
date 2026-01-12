# CI/CD IAM Policies

This directory contains least-privilege IAM policies required for Terraform CI/CD deployments. Policies are organized into two scopes:

- **`plan/`** - Read-only policies for `terraform init` and `terraform plan` (used in PR checks)
- **`apply/`** - Full write policies for `terraform apply` (used on protected branches)

## Two-Role CI/CD Architecture

For secure CI/CD pipelines, use **separate IAM roles** for plan and apply operations:

| Role | Scope | Used When | Permissions |
|------|-------|-----------|-------------|
| `github-actions-terraform-plan` | `plan` | Pull request checks | Read-only + explicit deny on mutations |
| `github-actions-terraform-apply` | `apply` | Push to `main` branch | Full create/update/delete |

### Security Benefits

1. **PR workflows cannot mutate infrastructure** - The plan role has explicit `Deny` statements blocking all write operations
2. **Apply role only used on protected branches** - Reduces blast radius of compromised credentials
3. **Least privilege** - Each role has exactly the permissions it needs

## Usage

Use the setup script to create and attach policies to an IAM role:

```bash
# Plan-only role for PR checks (read-only, cannot mutate infrastructure)
./tooling/setup_cicd_iam.sh --type role --name github-actions-terraform-plan --scope plan

# Apply role for main branch deployments (full permissions)
./tooling/setup_cicd_iam.sh --type role --name github-actions-terraform-apply --scope apply
```

The script will:
1. Create policies from the appropriate scope directory (`plan/` or `apply/`)
2. Name policies as `terraform-profile-website-<scope>-<policy-name>`
3. Attach all policies to the specified IAM role

## Policy Files

### plan/ (Read-Only)

| File | Purpose |
|------|---------|
| `read-only.json` | Read/Describe/List permissions for all services + explicit Deny on mutations |
| `s3.json` | Read-only access to Terraform state bucket |

### apply/ (Full Permissions)

| File | Purpose |
|------|---------|
| `acm.json` | ACM certificate management (request, validate, delete) |
| `alb.json` | Application Load Balancer, target groups, listeners |
| `ecs.json` | ECS clusters, task definitions, services, CloudWatch logs |
| `iam.json` | IAM roles, policies, instance profiles for ECS |
| `network.json` | VPC, subnets, security groups, route tables, internet gateways |
| `s3.json` | Read/write access to Terraform state backend |
| `ssm.json` | SSM Parameter Store (read ECS-optimized AMI parameter) |
| `waf.json` | WAFv2 Web ACL and rule management |

## GitHub Actions Workflow Example

```yaml
# .github/workflows/terraform.yml
jobs:
  plan:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
      pull-requests: write
    steps:
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::${{ secrets.AWS_ACCOUNT_ID }}:role/github-actions-terraform-plan
          aws-region: ${{ vars.AWS_REGION }}
      - run: terraform init && terraform plan

  apply:
    if: github.ref == 'refs/heads/main'
    needs: plan
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::${{ secrets.AWS_ACCOUNT_ID }}:role/github-actions-terraform-apply
          aws-region: ${{ vars.AWS_REGION }}
      - run: terraform init && terraform apply -auto-approve
```

## Policy Details (apply/)

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
