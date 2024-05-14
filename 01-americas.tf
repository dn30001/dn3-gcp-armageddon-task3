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

//=========================================================================

//Americas VM A
resource "google_compute_instance" "americas-vm-a" {
  boot_disk {
    auto_delete = true
    device_name = "americas-vm-a"

    initialize_params {
      image = "projects/windows-cloud/global/images/windows-server-2022-dc-v20240415"
      size  = 100
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

  name = "americas-vm-a"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/bionic-flux-414109/regions/us-east1/subnetworks/americas-subnet-a"
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
  zone = "us-east1-d"
}

//Americas VM B
resource "google_compute_instance" "americas-vm-b" {
  boot_disk {
    auto_delete = true
    device_name = "americas-vm-b"

    initialize_params {
      image = "projects/windows-cloud/global/images/windows-server-2022-dc-v20240415"
      size  = 100
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
  name         = "americas-vm-b"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/bionic-flux-414109/regions/us-west1/subnetworks/americas-subnet-b"
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
  zone = "us-west1-c"
}


