resource "digitalocean_loadbalancer" "master_public" {
    name = "${var.cluster_name}-master-lb"
    region = "${var.region}"
    redirect_http_to_https = "true"

    forwarding_rule {
        entry_port = 443
        entry_protocol = "https"
        target_port = 443
        target_protocol = "https" 
        tls_passthrough = "true"
    }

    healthcheck {
        port = 22
        protocol = "tcp"
    }

    droplet_ids = ["${digitalocean_droplet.masters.id}"]
}

# Main Cluster DNS entry
resource "digitalocean_record" "pub_cluster_url" {
  domain = "${var.domain_name}"
  name = "ocp"
  type  = "A"
  ttl   = 300
  value = "${digitalocean_loadbalancer.master_public.ip}"
}

# App wildcard subdomain entry
resource "digitalocean_record" "app_wildcard_cluster_url" {
  domain = "${var.domain_name}"
  name = "*.apps"
  type  = "A"
  ttl   = 300
  value = "${digitalocean_loadbalancer.master_public.ip}"
}