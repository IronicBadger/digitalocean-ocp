# Jumphost DNS records
resource "digitalocean_record" "jumphost" {

  # DNS zone where record should be created
  domain = "${var.domain_name}"

  name  = "jump"
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
      17525420, # ktzTP
      3296803,  # rMBP
      18403719  # origin
    ]
    tags = [
        "${digitalocean_tag.jumphost.id}",
        "${digitalocean_tag.openshift-cluster-name.id}"
    ]

    # Copies passphrase-less private key to jumphost
    provisioner "file" {
      source      = "~/.ssh/origin"
      destination = "/root/.ssh/id_rsa"
    }
    provisioner "file" {
      source      = "~/.ssh/origin.pub"
      destination = "/root/.ssh/id_rsa.pub"
    }
    # set ssh-key permissions correctly
    provisioner "remote-exec" {
        script = "scripts/set_sshkey_perms.sh"
    }

    # https://github.com/hashicorp/terraform/issues/2811    
    provisioner "remote-exec" {
        script = "scripts/update_fedora.sh"
    }
    provisioner "remote-exec" {
        script = "scripts/wait_for_boot.sh"
    }
}

output "jumphost_fqdn" {
    value = "${digitalocean_record.jumphost.fqdn}"
}