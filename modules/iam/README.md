# IAM Module

Creates IAM roles for ECS (EC2-backed) infrastructure with least-privilege permissions.

## Resources Created

- **Task Execution Role** - Used by ECS agent to pull images and write logs
- **Task Role** - Used by application containers for AWS API calls (empty by default)
- **EC2 Instance Role** - Used by EC2 instances running the ECS agent
- **Instance Profile** - Attached to ECS container instances
- **Custom Policies** - Scoped ECR access, CloudWatch logs/metrics

## Role Permissions

| Role | Permissions |
|------|-------------|
| Task Execution | `ecr:GetAuthorizationToken`, `ecr:BatchGetImage`, `ecr:GetDownloadUrlForLayer`, `logs:CreateLogStream`, `logs:PutLogEvents` |
| Task | None by default (add as needed for application) |
| EC2 Instance | ECS agent registration, scoped ECR pull, CloudWatch logs/metrics, SSM for ECS Exec |

## Security Features

- **Least-privilege**: All policies are scoped to specific resources where possible
- **ECR scoping**: Container image pull restricted to specified repository ARNs
- **CloudWatch scoping**: Logs restricted to `/ecs/${project_name}/*` log groups
- **Metrics namespace**: CloudWatch metrics restricted to `ECS/ContainerInsights`
- **SSM enabled**: Allows ECS Exec and Session Manager for debugging

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `project_name` | Project name (kebab-case) | `string` | Yes |
| `ecr_repository_arns` | List of ECR repository ARNs that ECS can pull from | `list(string)` | Yes |

## Outputs

| Name | Description |
|------|-------------|
| `task_execution_role_arn` | ARN of the task execution role |
| `task_execution_role_name` | Name of the task execution role |
| `task_role_arn` | ARN of the task role |
| `task_role_name` | Name of the task role |
| `ecs_instance_role_arn` | ARN of the EC2 instance role |
| `ecs_instance_role_name` | Name of the EC2 instance role |
| `ecs_instance_profile_name` | Name of the instance profile |
| `ecs_instance_profile_arn` | ARN of the instance profile |
