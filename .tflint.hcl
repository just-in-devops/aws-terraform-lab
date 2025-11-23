# Minimal tflint config; enable plugin for AWS rules.
# Customize rules and plugin versions as needed for your environment.

plugin "aws" {
  enabled = true
}

# Example: disable a noisy rule (customize to taste)
rule "aws_instance_invalid_type" {
  enabled = false
}