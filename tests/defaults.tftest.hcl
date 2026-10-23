mock_provider "aws" {
  mock_resource "aws_iam_policy" {
    defaults = {
      arn = "arn:aws:iam::123456789012:policy/example"
    }
  }
  mock_resource "aws_cloudwatch_log_group" {
    defaults = {
      arn = "arn:aws:logs:eu-west-1:123456789012:log-group:/aws/vendedlogs/states/example"
    }
  }
  mock_resource "aws_sfn_state_machine" {
    defaults = {
      arn = "arn:aws:states:eu-west-1:123456789012:stateMachine:example"
    }
  }
  mock_resource "aws_iam_role" {
    defaults = {
      arn = "arn:aws:iam::123456789012:role/example"
    }
  }
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }
}

variables {
  context = {
    organization = "olensys"
    environment  = "test"
    application  = "example"
    owner        = "platform"
    cost_center  = "eng"
  }
  name = "example"
  definition_json = jsonencode({
    StartAt = "Hello"
    States = {
      Hello = { Type = "Pass", Next = "Done" }
      Done  = { Type = "Pass", End = true }
    }
  })
}

run "test_logging_all" {
  # SMOKE: the logging_configuration block lives on the upstream state machine and cannot be read here; this observes the level the wrapper passes down. The real check is tests/complete.tftest.hcl.
  command = plan

  assert {
    condition     = output.logging_level == "ALL"
    error_message = "Logging level must be ALL."
  }

  assert {
    condition     = output.service_integrations.xray.xray == true
    error_message = "X-Ray tracing must be enabled."
  }
}

run "test_policy_scoped_to_lambdas" {
  command = plan

  variables {
    lambda_arns = [
      "arn:aws:lambda:eu-west-1:123456789012:function:one",
      "arn:aws:lambda:eu-west-1:123456789012:function:two",
    ]
  }

  assert {
    condition     = output.service_integrations.lambda.lambda == tolist(var.lambda_arns)
    error_message = "The Lambda invoke permission must be scoped to exactly lambda_arns."
  }
}

run "test_no_lambda_integration_without_arns" {
  command = plan

  assert {
    condition     = !contains(keys(output.service_integrations), "lambda")
    error_message = "No Lambda integration may be granted when lambda_arns is empty."
  }
}

run "test_type_validation" {
  command = plan

  variables {
    type = "BATCH"
  }

  expect_failures = [var.type]
}

run "test_definition_must_be_json" {
  command = plan

  variables {
    definition_json = "not json"
  }

  expect_failures = [var.definition_json]
}

run "test_log_retention_validation" {
  command = plan

  variables {
    log_retention_days = 31
  }

  expect_failures = [var.log_retention_days]
}

run "test_name_length_validation" {
  command = plan

  variables {
    name = join("", [for i in range(81) : "a"])
  }

  expect_failures = [var.name]
}

run "test_create_false_plans_nothing" {
  command = plan

  variables {
    create = false
  }

  assert {
    condition = alltrue([
      output.id == null, output.name == null, output.arn == null, output.role_arn == null,
      output.log_group_name == null, output.tags == null, output.service_integrations == null,
      output.logging_level == null,
    ])
    error_message = "Every output must be null when create is false."
  }
}

run "test_tags_contract" {
  command = plan

  variables {
    tags = { Owner = "x" }
    context = {
      organization = "olensys"
      environment  = "test"
      application  = "example"
      owner        = "platform"
      cost_center  = "eng"
      extra_tags   = { Owner = "y", Team = "z" }
    }
  }

  assert {
    condition     = output.tags.Owner == "x"
    error_message = "var.tags must win over context.extra_tags."
  }

  assert {
    condition     = output.tags.Team == "z"
    error_message = "context.extra_tags must be merged."
  }
}
