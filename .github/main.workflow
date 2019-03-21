workflow "Terraform" {
  resolves = "terraform-plan"
  on = "push"
}

action "terraform-fmt-module" {
  uses = "hashicorp/terraform-github-actions/fmt@v0.1.3"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
}

action "terraform-fmt-example-plan" {
  uses = "hashicorp/terraform-github-actions/fmt@v0.1.3"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "examples/basic-implementation"
  }
}

action "terraform-init" {
  uses = "hashicorp/terraform-github-actions/init@v0.1.3"
  needs = ["terraform-fmt-module", "terraform-fmt-example-plan"]
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

action "master-branch-only" {
  uses = "actions/bin/filter@master"
  needs = "terraform-validate"
  args = "branch master"
}

action "terraform-plan" {
  uses = "hashicorp/terraform-github-actions/plan@v0.1.3"
  needs = "master-branch-only"
  secrets = [
    "GITHUB_TOKEN",
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
  ]
  env = {
    TF_ACTION_WORKING_DIR = "examples/basic-implementation"
  }
}
