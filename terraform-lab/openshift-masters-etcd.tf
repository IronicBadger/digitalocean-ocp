# Master DNS records
resource "digitalocean_record" "masters" {
  count = "${var.master_count}"

  # DNS zone where record should be created
  domain = "${var.domain_name}"

  name  = "${var.cluster_name}-master-${count.index + 1}"
  type  = "A"
  ttl   = 300
  value = "${element(digitalocean_droplet.masters.*.ipv4_address, count.index)}"
}

# Master droplet instance(s)
resource "digitalocean_droplet" "masters" {
    count               = "${var.master_count}"

    name                = "${var.cluster_name}-openshift-master-${count.index + 1}"
    region              = "${var.region}"

    image               = "${var.image}"
    size                = "${var.size_master}"
    private_networking  = "${var.private_networking}"
    ssh_keys = [
      17525420, # ktzTP
      3296803,  # rMBP
      18403719  # origin
    ]
    tags = [
      "${digitalocean_tag.openshift-node.id}",
      "${digitalocean_tag.openshift-role-master.id}",
      "${digitalocean_tag.openshift-cluster-name.id}",
      "${digitalocean_tag.openshift-cluster-master-combo.id}"
    ]
    user_data = "${file("scripts/cloud-init.conf")}"

    # # required on MacOS as SSH agent is not respected! :(
    # connection {
    #     private_key = "${file("/Users/alex/.ssh/id_rsa")}"
    # }
    # # https://github.com/hashicorp/terraform/issues/2811        
    # provisioner "remote-exec" {
    #     script = "scripts/update_atomic.sh"
    # }
    # # wait for boot
    # provisioner "remote-exec" {
    #     script = "scripts/wait_for_boot.sh"
    # }
}