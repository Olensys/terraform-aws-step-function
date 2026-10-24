# terraform-aws-step-function

Step Functions state machine with full logging, X-Ray tracing and an execution role scoped to the Lambda functions it invokes

## Opinions

- Execution logging level is `ALL` with execution data included; the log group is `/aws/vendedlogs/states/<name>` with `log_retention_days` retention (default 30).
- X-Ray tracing is always enabled.
- The execution role may invoke only the functions in `lambda_arns` (never `*`); with an empty list no Lambda access is granted.

## Usage

```hcl
module "naming" {
  source  = "git::https://github.com/Olensys/terraform-null-naming.git?ref=v1.0.1"
  context = var.context
}

module "step_function" {
  source  = "git::https://github.com/Olensys/terraform-aws-step-function.git?ref=v1.0.0"
  name    = module.naming.name
  context = var.context

  definition_json = jsonencode({
    StartAt = "Hello"
    States  = { Hello = { Type = "Pass", End = true } }
  })
  lambda_arns = ["arn:aws:lambda:eu-west-1:123456789012:function:worker"]

  tags = module.naming.tags
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0, < 7.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_this"></a> [this](#module\_this) | terraform-aws-modules/step-functions/aws | 5.1.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_context"></a> [context](#input\_context) | Deployment context used for naming, tagging and environment-dependent defaults. | <pre>object({<br/>    organization = string<br/>    environment  = string<br/>    application  = string<br/>    component    = optional(string)<br/>    owner        = string<br/>    cost_center  = string<br/>    extra_tags   = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_definition_json"></a> [definition\_json](#input\_definition\_json) | Amazon States Language definition as a JSON string, for example from jsonencode(). | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Resource name. Lowercase letters, digits and hyphens. | `string` | n/a | yes |
| <a name="input_create"></a> [create](#input\_create) | Whether to create any resources. Set false to create nothing. | `bool` | `true` | no |
| <a name="input_lambda_arns"></a> [lambda\_arns](#input\_lambda\_arns) | ARNs of the Lambda functions the state machine may invoke. The execution role is granted lambda:InvokeFunction on exactly these. Empty grants no Lambda access. | `list(string)` | `[]` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Retention in days for the state machine CloudWatch log group. | `number` | `30` | no |
| <a name="input_policy_json"></a> [policy\_json](#input\_policy\_json) | Optional additional IAM policy document (JSON) attached to the execution role. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags merged onto every taggable resource, applied last. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | State machine type: STANDARD or EXPRESS. | `string` | `"STANDARD"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the state machine. Null when create is false. |
| <a name="output_id"></a> [id](#output\_id) | ID of the state machine. Null when create is false. |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | Name of the CloudWatch log group receiving execution logs. Null when create is false. |
| <a name="output_logging_level"></a> [logging\_level](#output\_logging\_level) | Execution logging level configured on the state machine. Null when create is false. |
| <a name="output_name"></a> [name](#output\_name) | Name of the state machine. Null when create is false. |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the execution role. Null when create is false. |
| <a name="output_service_integrations"></a> [service\_integrations](#output\_service\_integrations) | Service integrations granted to the execution role (X-Ray, and Lambda invoke scoped to lambda\_arns). Null when create is false. |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags applied to every taggable resource, with context.extra\_tags merged in. Null when create is false. |
<!-- END_TF_DOCS -->
