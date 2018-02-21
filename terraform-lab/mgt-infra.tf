# Jumphost DNS records
resource "digitalocean_record" "jumphost" {

  # DNS zone where record should be created
  domain = "${var.domain_name}"

  name  = "jumphost"
  type  = "A"
  ttl   = 300
  value = "${digitalocean_droplet.jumphost.ipv4_address}"
}

# Optional jumphost droplet
resource "digitalocean_droplet" "jumphost" {
    name                = "${var.cluster_name}-jumphost"
    region              = "${var.region}"

    image               = "fedora-27-x64"
    size                = "s-1vcpu-1gb"
    private_networking  = "${var.private_networking}"
    ssh_keys = [
      17525420,
      3296803,
      18403719
    ]
    tags = [
        "${digitalocean_tag.jumphost.id}",
        "${digitalocean_tag.openshift-cluster-name.id}"
    ]

    # https://github.com/hashicorp/terraform/issues/2811    
    provisioner "remote-exec" {
        script = "scripts/update_fedora.sh"
    }
    provisioner "remote-exec" {
        script = "scripts/wait_for_boot.sh"
    }
}
