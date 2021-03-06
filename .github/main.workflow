workflow "Terraform Pipeline" {
  resolves = ["terraform-fmt-module","terraform-plan-basic","terraform-plan-advanced"]
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "terraform-fmt-module" {
  uses = "bennycornelissen/terraform-github-actions/fmt@v0.1.3-benny"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
}

action "terraform-fmt-basic" {
  uses = "bennycornelissen/terraform-github-actions/fmt@v0.1.3-benny"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/basic-implementation"
  }
}

action "terraform-init-basic" {
  uses = "bennycornelissen/terraform-github-actions/init@v0.1.3-benny"
  needs = "terraform-fmt-basic"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/basic-implementation"
  }
}

action "terraform-validate-basic" {
  uses = "bennycornelissen/terraform-github-actions/validate@v0.1.3-benny"
  needs = "terraform-init-basic"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/basic-implementation"
  }
}

action "terraform-plan-basic" {
  uses = "bennycornelissen/terraform-github-actions/plan@v0.1.3-benny"
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

action "terraform-fmt-advanced" {
  uses = "bennycornelissen/terraform-github-actions/fmt@v0.1.3-benny"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/advanced-implementation"
  }
}

action "terraform-init-advanced" {
  uses = "bennycornelissen/terraform-github-actions/init@v0.1.3-benny"
  needs = "terraform-fmt-advanced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/advanced-implementation"
  }
}

action "terraform-validate-advanced" {
  uses = "bennycornelissen/terraform-github-actions/validate@v0.1.3-benny"
  needs = "terraform-init-advanced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/advanced-implementation"
  }
}

action "terraform-plan-advanced" {
  uses = "bennycornelissen/terraform-github-actions/plan@v0.1.3-benny"
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
