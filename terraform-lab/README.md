# Terraform

Use the Terraform code in this repository to create the required infrastructure on DigitalOcean to support an Openshift deployment.

### Configure provider

Generate a Personal Access Token with read/write scope from the [API tab] in the DigitalOcean web interface. Write this token to a file so that it can be referenced in configs. Note: performing this action will leave your token unencrypted on your local disk, please exercise care with this token.

    mkdir -p ~/.config/do
    echo "TOKEN" > ~/.config/do/token

Next, configure the Terraform DigialOcean provider to use the token by creating a `providers.tf` file.

    provider "digitalocean" {
        token = "${chomp(file("~/.config/do/token"))}"
        alias = "default"
    }

### Configure cluster droplets

Use the variables `master_count` and `worker_count` to determine the number of droplets created, and their respective roles, in the cluster.


