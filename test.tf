terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.6"
    }
  }
}
-+
provider "proxmox" {
  pm_api_url = "http://192.168.1.150:8006/api2/json"
  pm_api_token_id    = "72e01950-6e06-424f-beb4-8286aa9c7807"
  pm_password = "maximel@pve!terraform"
  pm_tls_insecure = true
  
}

resource "proxmox_vm_qemu" "vm" {
  count        = 1
  name         = "testvm_${count.index}"
  target_node  = "node-1"  # Remplacez "node1" par le nom du nœud cible approprié

  memory       = 2048
  cores        = 2

  network {
    model  = "virtio"
    bridge = "vmbr0"  # Remplacez par le nom du bridge réseau approprié sur Proxmox
    #address = "192.168.1.${count.index + 10}/24"  # Adresse IP de la machine virtuelle
  }

  disk {
    storage = "local-lvm"
    size    = "20G"
    format  = "vmdk"
    type    = "VirtIO SCSI single"
  }


  clone = "templatedeb11"
}