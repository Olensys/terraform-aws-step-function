variable "name" {
  description = "Resource name. Lowercase letters, digits and hyphens."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{1,80}$", var.name))
    error_message = "name must match ^[a-z0-9-]{1,80}$."
  }
}

variable "context" {
  description = "Deployment context used for naming, tagging and environment-dependent defaults."
  type = object({
    organization = string
    environment  = string
    application  = string
    component    = optional(string)
    owner        = string
    cost_center  = string
    extra_tags   = optional(map(string), {})
  })
  validation {
    condition     = contains(["dev", "staging", "prod", "test", "shared"], var.context.environment)
    error_message = "context.environment must be one of dev, staging, prod, test, shared."
  }
}

variable "create" {
  description = "Whether to create any resources. Set false to create nothing."
  type        = bool
  default     = true
}

variable "definition_json" {
  description = "Amazon States Language definition as a JSON string, for example from jsonencode()."
  type        = string
  validation {
    condition     = can(jsondecode(var.definition_json))
    error_message = "definition_json must be valid JSON."
  }
}

variable "type" {
  description = "State machine type: STANDARD or EXPRESS."
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "EXPRESS"], var.type)
    error_message = "type must be STANDARD or EXPRESS."
  }
}

variable "lambda_arns" {
  description = "ARNs of the Lambda functions the state machine may invoke. The execution role is granted lambda:InvokeFunction on exactly these. Empty grants no Lambda access."
  type        = list(string)
  default     = []
}

variable "policy_json" {
  description = "Optional additional IAM policy document (JSON) attached to the execution role."
  type        = string
  default     = null
}

variable "log_retention_days" {
  description = "Retention in days for the state machine CloudWatch log group."
  type        = number
  default     = 30
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.log_retention_days)
    error_message = "log_retention_days must be a value CloudWatch Logs accepts (1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653)."
  }
}

variable "tags" {
  description = "Tags merged onto every taggable resource, applied last."
  type        = map(string)
  default     = {}
}
