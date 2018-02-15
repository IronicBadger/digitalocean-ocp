### Cluster vars
variable "cluster_name" {
    description = "Cluster name - must be unique"
    type = "string"
    default = "openshift" # comment out if you want to be prompted every time or set in tfvars
}

variable "master_count" {
  type        = "string"
  default     = "1"
  description = "Number of masters"
}

variable "worker_count" {
  type        = "string"
  default     = "2"
  description = "Number of app / worker nodes"
}

### DNS vars

variable "domain_name" {
    type = "string"
    description = "Domain (e.g. domain.example.com)"
}

### Droplet vars

variable "image" {
    description = "Execute `doctl compute image list --public` for possible values"
    default = "fedora-27-x64-atomic"
}

variable "region" {
    description = "Execute `doctl compute region list` for possible values"
    #ams3 set to default as it has s3 compatible 'spaces' available
    default = "ams3"
}

variable "size" {
    description = "Execute `doctl compute size list` for possible values"
    default = "s-1vcpu-1gb" 
}

variable "private_networking" {
    description = "True or False for private inter-droplet networking"
    default = "true"
}

### Tags

resource "digitalocean_tag" "openshift-node" {
  name = "openshift"
}

resource "digitalocean_tag" "openshift-role-master" {
  name = "master"
}

resource "digitalocean_tag" "openshift-role-worker" {
  name = "worker"
}

resource "digitalocean_tag" "openshift-cluster-name" {
  name = "${var.cluster_name}"
}

resource "digitalocean_tag" "openshift-cluster-master-combo" {
  name = "${var.cluster_name}-master"
}

resource "digitalocean_tag" "openshift-cluster-worker-combo" {
  name = "${var.cluster_name}-worker"
}