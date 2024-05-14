//Americas Network
resource "google_compute_network" "americas-network" {
  project                 = "bionic-flux-414109"
  name                    = "americas-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

//Americas Subnet A
resource "google_compute_subnetwork" "americas-subnet-a" {
  project = "bionic-flux-414109"
  name    = "americas-subnet-a"
  region  = "us-east1"
  ip_cidr_range = "172.16.13.0/24"
  network = google_compute_network.americas-network.id
  private_ip_google_access = true
}

//Americas Subnet B
resource "google_compute_subnetwork" "americas-subnet-b" {
  project = "bionic-flux-414109"
  name    = "americas-subnet-b"
  region  = "us-west1"
  ip_cidr_range = "172.16.23.0/24"
  network = google_compute_network.americas-network.id
  private_ip_google_access = true
}

//====================================================================

//Americas VM A
resource "google_compute_instance" "americas-vm-a" {
    name = "americas-vm-a"
    zone = "us-east1-b"
  boot_disk {
    auto_delete = true
    device_name = "americas-vm-a"

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

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = google_compute_subnetwork.americas-subnet-a.id
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }
}

// Americas VM B
resource "google_compute_instance" "americas-vm-b" {
    name = "americas-vm-b"
    zone = "us-west1-a"
  boot_disk {
    auto_delete = true
    device_name = "americas-vm-b"

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

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = google_compute_subnetwork.americas-subnet-b.id
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }
}
  zone = "us-west1-c"
}


