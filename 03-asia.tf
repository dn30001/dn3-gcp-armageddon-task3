resource "google_compute_network" "asia-network" {
  project                 = "bionic-flux-414109"
  name                    = "asia-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "asia-subnet-a" {
  project       = "bionic-flux-414109"
  name          = "asia-subnet-a"
  region        = "asia-east1"
  ip_cidr_range = "192.168.33.0/24"
  network       =  google_compute_network.asia-network.id
}

//Asia VM

resource "google_compute_instance" "asia-vm-a" {
  boot_disk {
    auto_delete = true
    device_name = "asia-vm-a"

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

  machine_type = "n2-standard-2"
  name         = "asia-vm-a"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/bionic-flux-414109/regions/asia-east1/subnetworks/asia-subnet-a"
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

  zone = "asia-east1-b"
}
