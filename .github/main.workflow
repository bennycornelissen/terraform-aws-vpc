workflow "Terraform Module Pipelines" {
  resolves = "terraform-fmt-module"
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "terraform-fmt-module" {
  uses = "hashicorp/terraform-github-actions/fmt@v0.1.3"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
}

workflow "Terraform Basic Plan Pipeline" {
  resolves = "terraform-plan-basic"
  on = "pull_request"
}

action "terraform-fmt-basic" {
  uses = "hashicorp/terraform-github-actions/fmt@v0.1.3"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/basic-implementation"
  }
}

action "terraform-init-basic" {
  uses = "hashicorp/terraform-github-actions/init@v0.1.3"
  needs = "terraform-fmt-basic"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/basic-implementation"
  }
}

action "terraform-validate-basic" {
  uses = "hashicorp/terraform-github-actions/validate@v0.1.3"
  needs = "terraform-init-basic"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/basic-implementation"
  }
}

action "terraform-plan-basic" {
  uses = "bennycornelissen/terraform-github-actions/plan@verbose_comments"
  needs = "terraform-validate-basic"
  secrets = [
    "GITHUB_TOKEN",
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
  ]
  env = {
    TF_ACTION_WORKING_DIR = "examples/basic-implementation"
  }
}

workflow "Terraform Advanced Plan Pipeline" {
  resolves = "terraform-plan-advanced"
  on = "pull_request"
}
action "terraform-fmt-advanced" {
  uses = "hashicorp/terraform-github-actions/fmt@v0.1.3"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/advanced-implementation"
  }
}

action "terraform-init-advanced" {
  uses = "hashicorp/terraform-github-actions/init@v0.1.3"
  needs = "terraform-fmt-advanced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/advanced-implementation"
  }
}

action "terraform-validate-advanced" {
  uses = "hashicorp/terraform-github-actions/validate@v0.1.3"
  needs = "terraform-init-advanced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/advanced-implementation"
  }
}

action "terraform-plan-advanced" {
  uses = "bennycornelissen/terraform-github-actions/plan@verbose_comments"
  needs = "terraform-validate-advanced"
  secrets = [
    "GITHUB_TOKEN",
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
  ]
  env = {
    TF_ACTION_WORKING_DIR = "examples/advanced-implementation"
  }
}
