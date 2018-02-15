# Worker DNS records
resource "digitalocean_record" "workers" {
  count = "${var.worker_count}"

  # DNS zone where record should be created
  domain = "${var.domain_name}"

  name  = "${var.cluster_name}-worker-${count.index + 1}"
  type  = "A"
  ttl   = 300
  value = "${element(digitalocean_droplet.workers.*.ipv4_address, count.index)}"
}

# Worker droplet instance(s)
resource "digitalocean_droplet" "workers" {
    count               = "${var.worker_count}"

    name                = "${var.cluster_name}-openshift-worker-${count.index + 1}"
    region              = "${var.region}"

    image               = "${var.image}"
    size                = "${var.size}"
    private_networking  = "${var.private_networking}"
    ssh_keys = [
      17525420,
      3296803
    ]
    tags = [
        "${digitalocean_tag.openshift-node.id}",
        "${digitalocean_tag.openshift-role-worker.id}",
        "${digitalocean_tag.openshift-cluster-name.id}",
        "${digitalocean_tag.openshift-cluster-worker-combo.id}"
    ]

}
