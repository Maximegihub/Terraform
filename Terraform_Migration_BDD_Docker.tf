# Configuration du fournisseur vSphere pour ESXi 2
provider "vsphere" {
  user           = "votre_nom_utilisateur"
  password       = "votre_mot_de_passe"
  vsphere_server = "adresse_IP_ESXi2"
}

# Création de la machine virtuelle sur ESXi 2
resource "vsphere_virtual_machine" "web_server" {
  name             = "web-server"
  resource_pool_id = "ressource_pool_ESXi2"
  datastore_id     = "datastore_ESXi2"
  folder           = "votre_dossier"
  vcpu             = 2
  memory           = 4096
  guest_id         = "ubuntu64Guest"  # Remplacez par l'ID de votre système d'exploitation
  network_interface {
    network_id   = "réseau_192.168.201.0/24"  # Remplacez par le bon réseau
    adapter_type = "vmxnet3"
  }
}

# Configuration de la provision de la machine virtuelle (installation du serveur web et Docker)
resource "null_resource" "configure_web_server" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "remote-exec" {
    inline = [
      # Commandes d'installation/configuration du serveur web (par exemple, Apache2)
      "sudo apt update",
      "sudo apt install -y apache2",  # Exemple : installation d'Apache2
      # Copiez vos fichiers du site web ici

      # Installation de Docker
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
      "sudo usermod -aG docker ${USER}",  # Ajoutez l'utilisateur à group Docker (reconnectez-vous après)

      # Installez Docker Compose (remplacez les versions par celles que vous souhaitez)
      "sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose"
    ]
  }

  depends_on = [vsphere_virtual_machine.web_server]
}

# Copiez votre fichier Docker Compose sur la machine virtuelle (assurez-vous qu'il est présent dans le répertoire local)
resource "file" "docker_compose_file" {
  source      = "chemin_vers_votre_docker_compose.yml"
  destination = "/path/to/docker-compose.yml"  # Répertoire de destination sur la machine virtuelle
  depends_on  = [vsphere_virtual_machine.web_server]
}

# Déclaration des sorties pour afficher des informations utiles
output "web_server_ip" {
  value = vsphere_virtual_machine.web_server.guest_ip_addresses[0]
}
