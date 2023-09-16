data "github_repository" "repo" {
    full_name = "fixmenu/terraform_aws_github_actions"
}

resource "github_repository_environment" "test_env" {
  repository = data.github_repository.repo.name
  environment = "test_env"
}

resource "github_actions_environment_secret" "ec2-ssh-key" {
  environment = github_repository_environment.test_env.environment
  secret_name = "aws_ec2_ssh_key"
  plaintext_value = file("my-keypair.pub")
  repository = data.github_repository.repo.name
}
