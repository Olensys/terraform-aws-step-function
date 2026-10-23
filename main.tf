locals {
  tags = merge(var.context.extra_tags, var.tags)

  log_group_name = "/aws/vendedlogs/states/${var.name}"
  logging_level  = "ALL"

  # X-Ray is always on; Lambda invoke is granted only on the listed functions.
  service_integrations = merge(
    { xray = { xray = true } },
    length(var.lambda_arns) > 0 ? { lambda = { lambda = var.lambda_arns } } : {},
  )
}

module "this" {
  source  = "terraform-aws-modules/step-functions/aws"
  version = "5.1.1"

  create = var.create

  name       = var.name
  definition = var.definition_json
  type       = var.type

  logging_configuration = {
    level                  = local.logging_level
    include_execution_data = "true"
  }
  cloudwatch_log_group_name              = local.log_group_name
  cloudwatch_log_group_retention_in_days = var.log_retention_days
  attach_cloudwatch_logs_policy          = true

  service_integrations = local.service_integrations

  attach_policy_json = var.policy_json != null
  policy_json        = var.policy_json

  tags = local.tags
}
