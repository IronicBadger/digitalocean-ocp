variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}

provider "digitalocean" {
    token = "${chomp(file("~/.config/do/token"))}"
}
