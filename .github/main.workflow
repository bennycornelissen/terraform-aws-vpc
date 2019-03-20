workflow "Terraform" {
  resolves = "terraform-validate"
  on = "push"
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

action "terraform-fmt-example-plan" {
  uses = "hashicorp/terraform-github-actions/fmt@v0.1.3"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/basic-implementation"
  }
}

action "terraform-init" {
  uses = "hashicorp/terraform-github-actions/init@v0.1.3"
  needs = ["terraform-fmt-module","terraform-fmt-example-plan"]
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/basic-implementation"
  }
}

action "terraform-validate" {
  uses = "hashicorp/terraform-github-actions/validate@v0.1.3"
  needs = "terraform-init"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/basic-implementation"
  }
}
