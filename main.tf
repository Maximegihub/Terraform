terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"  # Choisir le plugin adéquatte#
      version = "2.9.11"            # Sélectionner la dernière version#
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true                                #skipé la vérification TLS 
  pm_api_url      = "http://Serveur_cible/api2/json"    # Serveur cible#
  pm_api_token_id         = "id du token utilisé"
  pm_api_token_secret = "token de l'utilisateur"
}

resource "proxmox_vm_qemu" "machine cible qui servira a etre cloner" {
  name = "nommer votre machine"
  clone = "clone source"
  os_type = "cloud-init"
  target_node = "Nom du noeud sur votre serveur"
  cpu = "host"
  memory  = 2048
  cores   = 2
  sockets = 1
  scsihw = "virtio-scsi-single"

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  disk {
    storage   = "chemin ou est stocké le disque "
    size      = "10G"
    type      = "scsi"
  }
}
