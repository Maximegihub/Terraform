# Déclaration du fournisseur vSphere
provider "vsphere" {
  user           = "votre_nom_utilisateur"
  password       = "votre_mot_de_passe"
  vsphere_server = "adresse_IP_vCenter"
}

# Création d'une machine virtuelle Docker sur ESXi 2
resource "vsphere_virtual_machine" "docker_vm" {
  name             = "docker-vm"
  resource_pool_id = "ressource_pool_ID"
  datastore_id     = "datastore_ID"
  folder           = "votre_dossier"
  vcpu             = 2
  memory           = 4096
  guest_id         = "ubuntu64Guest"
  network_interface {
    network_id   = "réseau_ID"
    adapter_type = "vmxnet3"
  }
}

# Configuration des fichiers Docker et du site web
connection {
  type        = "ssh"
  host        = vsphere_virtual_machine.docker_vm.guest_ip_addresses[0]
  user        = "votre_utilisateur_ssh"
  private_key = file("chemin_vers_votre_clé_privée")
}

# Copie des fichiers du site web vers la machine virtuelle Docker
resource "null_resource" "copy_site_files" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "file" {
    source      = "chemin_vers_les_fichiers_du_site"
    destination = "/var/www/html"
  }

  depends_on = [vsphere_virtual_machine.docker_vm]
}

# Installation de Docker et du site web sur la machine virtuelle Docker
resource "null_resource" "install_docker_and_site" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo docker run -d -p 80:80 -v /var/www/html:/var/www/html --name my_website_container nginx",
    ]
  }

  depends_on = [null_resource.copy_site_files]
}
