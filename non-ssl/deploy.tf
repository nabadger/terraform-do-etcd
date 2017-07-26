variable "do_token" {}
variable "ssh_fingerprint" {}
variable "ssh_private_key" {}

variable "ETCD_COUNT" {
    default = "3"
}

variable "ETCD_DISCOVERY_URL_FILE" {
    default = "etcd_discovery_url.txt"
}

provider "digitalocean" {
    token = "${var.do_token}"
}


###############################################################################
#
# Etcd host
#
###############################################################################
resource "digitalocean_droplet" "etcd" {
    image = "coreos-stable"
    name = "coreos-etcd-${count.index+1}-${var.ETCD_COUNT}"
    region = "lon1"
    count = "${var.ETCD_COUNT}"
    private_networking = true
    size = "512mb"
    user_data = "${data.template_file.etcd_cloud_config.rendered}"
    ssh_keys = ["${split(",", var.ssh_fingerprint)}"]
    
    provisioner "remote-exec" {
        inline = [
            "sudo systemctl start etcd2",
            "sudo systemctl enable etcd2",
        ]
        connection {
            type = "ssh",
            user = "core",
            private_key = "${file(var.ssh_private_key)}"
        }
    }
}

data "template_file" "etcd_cloud_config" {
    template = "${file("${path.module}/etcd.yaml")}"
    depends_on = ["null_resource.etcd_discovery_url"]
    vars {
        etcd_discovery_url = "${file(var.ETCD_DISCOVERY_URL_FILE)}"
        siez = "${var.ETCD_COUNT}"
    }
}

resource "null_resource" "etcd_discovery_url" {
    provisioner "local-exec" {
        command = "curl https://discovery.etcd.io/new?size=${var.ETCD_COUNT} > ${var.ETCD_DISCOVERY_URL_FILE}"
    }
}
