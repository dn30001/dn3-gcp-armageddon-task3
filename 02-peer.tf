resource "google_compute_network_peering" "asia_europe_peering" {
  name          = "asia-to-europe-peering"
  network       = google_compute_network.asia-network.id
  peer_network  = google_compute_network.europe-hq-network.id
}

resource "google_compute_network_peering" "europe_asia_peering" {
  name          = "europe-to-asia-peering"
  network       = google_compute_network.europe-hq-network.id
  peer_network  = google_compute_network.asia-network.id
}