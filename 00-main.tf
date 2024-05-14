terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.28.0"
    }
  }
}

provider google {
  # Configuration options
project     = "bionic-flux-414109"
credentials = "bionic-flux-414109-6a39dd7bbe43.json"
}

//HQ Network in Europe
resource "google_compute_network" "europe-hq-network" {
  project                 = "bionic-flux-414109"
  name                    = "europe-hq-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

//HQ Subnet
resource "google_compute_subnetwork" "europe-hq-subnet" {
  project         = "bionic-flux-414109"
  name            = "europe-hq-subnet"
  region          = "europe-west1"
  ip_cidr_range   = "10.180.30.0/24"
  network         = google_compute_network.europe-hq-network.id
}

//====================================================================

//HQ VM
resource "google_compute_instance" "europe-hq-vm" {
  boot_disk {
    auto_delete = true
    device_name = "europe-hq-vm"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240415"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-medium"

  metadata = {
    startup-script = "apt update\napt install -y apache2\ncat <<EOF > /var/www/html/index.html\n<html><body>\n<h2>Welcome to Armageddon</h2>\n<h3>Created with a direct input startup script!</h3>\n<h4>KEISHA IS WATCHING!! SO I SHOWED HER THE BUSINESS</h4>\n</body></html>\nEOF"
  }

  name = "europe-hq-vm"

  network_interface {
    network =  google_compute_network.europe-hq-network.id
    subnetwork = google_compute_subnetwork.europe-hq-subnet.id

    access_config {
      
    }
}

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "380985038603-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server"]
  zone = "europe-west1-b"
}