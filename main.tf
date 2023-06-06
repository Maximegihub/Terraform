terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = "http://10.27.0.100:8006/api2/json"
  pm_api_token_id         = "MaximeL@pve!terraform"
  pm_api_token_secret = "fd0f409e-f367-41c0-81d6-bebea5931381"
}

resource "proxmox_vm_qemu" "maximel2" {
  name = "test"
  clone = "maximel2"
  os_type = "cloud-init"
  target_node = "Grp1-Srv1"
  cpu = "host"
  memory  = 2048
  cores   = 2
  sockets = 1
  scsihw = "virtio-scsi-single"

 #os_type = "l26"

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  disk {
    storage   = "local"
    size      = "10G"
    type      = "scsi"
    #clone     = "template:~/terraformimage/debian-11-genericcloud-amd64"
    #full_clone = true
  }
}