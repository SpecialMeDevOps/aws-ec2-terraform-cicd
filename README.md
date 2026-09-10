# AWS EC2 Terraform CI/CD with Streamlit

This project deploys a Python Streamlit frontend to AWS EC2 using Terraform,
Docker, GitHub Actions, and GitHub Container Registry (GHCR).

## Architecture

```text
GitHub push
    |
    v
GitHub Actions
    |-- Build Streamlit Docker image
    |-- Push image to GHCR
    |-- terraform init / validate / plan / apply
    v
AWS EC2
    |-- Install Docker
    |-- Pull the GHCR image
    |-- Run the Streamlit container on port 8501
```

## Project structure

```text
.
|-- app/
|   |-- app.py              # Streamlit frontend
|   `-- dockerfile           # Streamlit Docker image
|-- .github/workflows/
|   `-- terraform.yml       # Build, push, and deploy pipeline
|-- main.tf                 # AWS provider, EC2, VPC data, and security group
|-- variables.tf            # Terraform input variables
|-- outputs.tf              # EC2 and security group outputs
|-- terraform.tfvars        # Local Terraform values
|-- .gitignore
`-- README.md
```

## Application

The Streamlit frontend in `app/app.py` provides:

- CloudDeploy landing page
- Streamlit, Docker, and AWS EC2 information cards
- Deployment status metrics
- Refresh status button

The application listens on port `8501`.

## Local Docker run

From the project root:

```bash
docker build -t terraform-ec2-streamlit ./app
docker run --rm -p 8501:8501 terraform-ec2-streamlit
```

Open:

```text
http://localhost:8501
```

## Terraform configuration

Before deployment, update `terraform.tfvars`:

```hcl
aws_region       = "us-east-1"
project_name     = "terraform-ec2"
ami_id           = "ami-your-region-specific-id"
instance_type    = "t2.micro"
key_name         = "your-existing-key-pair-name"
allowed_ssh_cidr = "YOUR_PUBLIC_IP/32"
app_port         = 8501
docker_image     = "ghcr.io/YOUR_GITHUB_USERNAME/terraform-ec2-streamlit:latest"
```

The AMI must exist in the selected AWS region, and the EC2 key pair must
already exist in AWS.

Run Terraform locally:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Terraform creates:

- An EC2 instance in the default VPC
- A security group allowing SSH and Streamlit traffic
- A public IP address
- Docker installation and container startup through EC2 `user_data`

## GitHub Actions setup

The workflow in `.github/workflows/terraform.yml` runs on pushes to `main` or
manually through `workflow_dispatch`.

It automatically:

1. Builds the image from `app/dockerfile`.
2. Pushes `latest` and the commit-tagged image to GHCR.
3. Runs Terraform formatting, initialization, validation, and plan.
4. Applies the Terraform plan.
5. Starts the new image on EC2.

### Required GitHub secrets

Add these under **Settings > Secrets and variables > Actions > Secrets**:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### Required GitHub variables

Add these under **Settings > Secrets and variables > Actions > Variables**:

- `AWS_REGION`
- `AMI_ID`
- `EC2_KEY_NAME`

Optional variables:

- `PROJECT_NAME`
- `ALLOWED_SSH_CIDR`

The GitHub Actions `GITHUB_TOKEN` is used to push the image to GHCR. Make the
GHCR package public, or add a private-registry pull login to the EC2 startup
script before deploying a private image.

## Accessing the deployed app

After a successful workflow, find the EC2 public IP in the Terraform output or
AWS console and open:

```text
http://EC2_PUBLIC_IP:8501
```

## Security notes

- Do not commit AWS access keys, private keys, or state files.
- Prefer `YOUR_PUBLIC_IP/32` instead of `0.0.0.0/0` for SSH access.
- Use an IAM user or role with only the permissions required by this project.
- For production, use an encrypted remote Terraform state backend.
