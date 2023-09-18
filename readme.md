## Getting Started with [Your Repository Name]

### 1. Fork the Repository
Start by forking this repository to your own GitHub account.

### 2. Install AWS CLI
Ensure you have the AWS Command Line Interface (CLI) installed. If not, you can [download it here](https://aws.amazon.com/cli/).

### 3. Configure AWS CLI
Run the following command:
```bash
aws configure
```
You'll be prompted to enter your AWS `access_key` and `secret_key`. Fill in the necessary details.

### 4. Generate an SSH Key
Create an SSH key pair named `my-keypair` for use with AWS:
```bash
ssh-keygen -t rsa -f my-keypair
```
Keep your keys safe, as you'll need them for accessing resources.

### 5. Set Up Terraform Secrets
Create a file in the root directory named `secrets.tfvars`.

### 6. Generate GitHub Token
1. Create a new personal access token on GitHub. [Follow this guide if you're unsure how to create one.](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token)
2. Once you have your token, enter it in the `secrets.tfvars` file:
```hcl
github_secret = "<YOUR_TOKEN>"
```
Replace `<YOUR_TOKEN>` with your actual token value.

### 7. Configure GitHub Repository Name
Open the `github-actions.tf` file and modify the `github_repository` attribute to match the name of your forked repository.

### 8. Configure Terraform Variables
Open the `variables.tf` file to configure any Terraform variables as per your requirements.

### 9. Run Terraform Commands
Initialize and apply your Terraform configuration:
```bash
terraform plan -var-file="secrets.tfvars"
```
Then:
```bash
terraform apply -var-file="secrets.tfvars" -auto-approve
```

### 10. Deploy
Ensure that your EC2 instance is up and running. From this point forward, any updates made to the my-blog directory on main branch will automatically be packaged and deployed in a Docker container and run on aws EC2 instance. You're encouraged to tailor the github-actions workflow to better suit your specific requirements.