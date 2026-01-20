output "id" {
  description = "ECS cluster id"
  value       = aws_ecs_cluster.this.id
}

output "name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.this.name
}
