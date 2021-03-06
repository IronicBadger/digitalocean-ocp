resource "digitalocean_firewall" "rules" {
  name = "${var.cluster_name}"

  tags = ["${var.cluster_name}-master", "${var.cluster_name}-worker", "${var.cluster_name}-infra", "${var.cluster_name}-bastion"]

  # allow ssh, http/https ingress, and peer-to-peer traffic
  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol    = "udp"
      port_range  = "1-65535"
      source_tags = [
        "${digitalocean_tag.openshift-cluster-master-combo.name}", 
        "${digitalocean_tag.openshift-cluster-worker-combo.name}", 
        "${digitalocean_tag.openshift-cluster-infra-combo.name}", 
        "${digitalocean_tag.bastion.name}"
      ]
    },
    {
      protocol    = "tcp"
      port_range  = "1-65535"
      source_tags = [
        "${digitalocean_tag.openshift-cluster-master-combo.name}", 
        "${digitalocean_tag.openshift-cluster-worker-combo.name}", 
        "${digitalocean_tag.openshift-cluster-infra-combo.name}", 
        "${digitalocean_tag.bastion.name}"
      ]
    },
  ]

  # allow all outbound traffic
  outbound_rule = [
    {
      protocol              = "tcp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "udp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "icmp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]
}