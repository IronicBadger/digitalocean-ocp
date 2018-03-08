# bastion DNS record
resource "digitalocean_record" "bastion" {

  # DNS zone where record should be created
  domain = "${var.domain_name}"

  name  = "${var.cluster_name}-bastion"
  type  = "A"
  ttl   = 300
  value = "${digitalocean_droplet.bastion.ipv4_address}"
}

# Optional bastion droplet
resource "digitalocean_droplet" "bastion" {
    name                = "${var.cluster_name}-bastion"
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
        "${digitalocean_tag.bastion.id}",
        "${digitalocean_tag.openshift-cluster-name.id}"
    ]

    # required on MacOS as SSH agent is not respected! :(
    connection {
        private_key = "${file("/Users/alex/.ssh/id_rsa")}"
    }
    # Copies passphrase-less private key to bastion
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

    # # https://github.com/hashicorp/terraform/issues/2811    
    # provisioner "remote-exec" {
    #     script = "scripts/update_fedora.sh"
    # }
    # provisioner "remote-exec" {
    #     script = "scripts/wait_for_boot.sh"
    # }
}

output "bastion_fqdn" {
    value = "${digitalocean_record.bastion.fqdn}"
}