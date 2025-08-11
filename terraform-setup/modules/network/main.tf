resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
  project = var.project_id
}

resource "google_compute_subnetwork" "connector_subnet" {
  name          = "connector-subnet"
  project     = var.project_id
  ip_cidr_range = "10.0.1.0/28"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "database_subnet" {
  name                     = "database-subnet"
  project                  = var.project_id
  ip_cidr_range            = "10.0.2.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
}

# Firewall rule to allow MySQL (3306) only
resource "google_compute_firewall" "allow_sql" {
  name    = "allow-mysql"
  network = google_compute_network.vpc_network.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["private-sql"]
  direction     = "INGRESS"
}

# Firewall rule to allow IAP IP ranges
resource "google_compute_firewall" "iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.vpc_network.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["private-sql"]  # Must match VM's tag!
  direction     = "INGRESS"
}


# Create Cloud Router
resource "google_compute_router" "router" {
  name    = "nat-router"
  region  = var.region
  network = google_compute_network.vpc_network.name
  project = var.project_id
}

# Configure Cloud NAT
resource "google_compute_router_nat" "nat_config" {
  name                               = "nat-config"
  router                             = google_compute_router.router.name
  project                            = var.project_id
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.database_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# VPC connector in public subnet
resource "google_vpc_access_connector" "vpc_connector" {
  name          = "serverless-connector"
  region        = var.region
  project       = var.project_id
  subnet {
    name = google_compute_subnetwork.connector_subnet.name
  }
  machine_type = "f1-micro"
  min_instances = 2
  max_instances = 3
}
