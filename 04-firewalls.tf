resource "google_compute_firewall" "http_europe" {
  name      = "http-europe"
    network = google_compute_network.europe-hq-network.name
    
        allow {
            protocol    = "tcp"
            ports       = ["80"]
        }
        source_ranges = ["10.180.30.0/24", "172.16.13.0/24", "172.16.23.0/24", "192.168.33.0/24"]
}

resource "google_compute_firewall" "allow_http_america_to_europe" {
  name      = "allow-http-america-to-europe"
  network   = google_compute_network.americas-network.name

    allow {
        protocol    = "tcp"
        ports       = ["80", "22"]
    }
    source_ranges = [ "0.0.0.0/0", "35.235.240.0/20" ]
}

resource "google_compute_firewall" "allow_rdp_asia" {
    name    = "allow-rdp-asia"
    network = google_compute_network.asia-network.name
    
    allow {
        protocol = "tcp"
        ports    = ["3389"]
    }
    
    source_ranges = ["0.0.0.0/0"]
}