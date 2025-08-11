resource "google_project_service" "compute_api" {
  project = var.project_id
  service = "compute.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy = false
}
# enable iap api
resource "google_project_service" "project" {
  project = var.project_id
  service = "iam.googleapis.com"

  disable_on_destroy = false
}
# VM in private subnet
resource "google_compute_instance" "database_vm" {
  name         = "database-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  project      = var.project_id

  tags = ["private-sql"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = var.subnet
    subnetwork_project = var.project_id
  }

  metadata_startup_script = <<-EOT
    sudo apt update
    sudo apt install -y mysql-server
    sudo systemctl start mysql.service
  EOT
}