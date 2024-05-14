//VPN Gateway Europe
resource "google_compute_vpn_gateway" "vpn_gateway_europe" {
  name      = "vpn-gateway-europe"
  network   = google_compute_network.europe-hq-network.id
  region    = "europe-west1"
}

//VPN Gateway Asia
resource "google_compute_vpn_gateway" "vpn_gateway_asia" {
  name      = "vpn-gateway-asia"
  network   = google_compute_network.asia-network.id
  region    = "asia-east1"
  
}

//External Static IP Addresses for VPN Gateways
resource "google_compute_address" "vpn_europe_ip" {
  name      = "vpn-europe-ip"
  region    = "europe-west1"
}

resource "google_compute_address" "vpn_asia_ip" {
  name      = "vpn-asia-ip"
  region    = "asia-east1"
}

//VPN Tunnel Asia to Europe
data "google_secret_manager_secret_version" "vpn-shared-secret" {
  secret    = "vpn-shared-secret"
  version   = 1
  }

resource "google_compute_vpn_tunnel" "vpn_tunnel_asia_to_europe" {
  name                  = "vpn-tunnel-asia-to-europe"
  region                = "asia-east1"
  target_vpn_gateway    = google_compute_vpn_gateway.vpn_gateway_asia.id
  peer_ip               = google_compute_address.vpn_europe_ip.address
  shared_secret         = data.google_secret_manager_secret_version.vpn-shared-secret.secret_data
  ike_version           = 2

  local_traffic_selector    = ["192.168.33.0/24"]
  remote_traffic_selector   = ["10.180.30.0/24"]

  depends_on = [google_compute_forwarding_rule.asia_esp, 
                google_compute_forwarding_rule.asia_udp500, 
                google_compute_forwarding_rule.asia_udp4500]
}

//Route for Asia to Europe
resource "google_compute_route" "asia_to_europe_route" {
  name                  = "asia-to-europe-route"
  network               = google_compute_network.asia-network.id
  dest_range            = "10.150.11.0/24"
  next_hop_vpn_tunnel   = google_compute_vpn_tunnel.vpn_tunnel_asia_to_europe.id
  priority              = 1000
}

//Forwarding Rules for Asia VPN
resource "google_compute_forwarding_rule" "asia_esp" {
  name          = "asia-esp"
  region        = "asia-east1"
  ip_protocol   = "ESP"
  ip_address    = google_compute_address.vpn_asia_ip.address
  target        = google_compute_vpn_gateway.vpn_gateway_asia.id
}

resource "google_compute_forwarding_rule" "asia_udp500" {
  name          = "asia-udp500"
  region        = "asia-east1"
  ip_protocol   = "UDP"
  port_range    = "500"
  ip_address    = google_compute_address.vpn_asia_ip.address
  target        = google_compute_vpn_gateway.vpn_gateway_asia.id
}

resource "google_compute_forwarding_rule" "asia_udp4500" {
  name          = "asia-udp4500"
  region        = "asia-east1"
  ip_protocol   = "UDP"
  port_range    = "4500"
  ip_address    = google_compute_address.vpn_asia_ip.address
  target        = google_compute_vpn_gateway.vpn_gateway_asia.id
}

//Reverse VPN Tunnel from Europe to Asia
resource "google_compute_vpn_tunnel" "vpn_tunnel_europe_to_asia" {
  name                  = "vpn-tunnel-europe-to-asia"
  region                = "europe-west1"
  target_vpn_gateway    = google_compute_vpn_gateway.vpn_gateway_europe.id
  peer_ip               = google_compute_address.vpn_asia_ip.address
  shared_secret         = data.google_secret_manager_secret_version.vpn-shared-secret.secret_data
  ike_version           = 2

  local_traffic_selector    = ["10.180.30.0/24"]
  remote_traffic_selector   = ["192.168.33.0/24"]

  depends_on = [google_compute_forwarding_rule.europe_esp, 
                google_compute_forwarding_rule.europe_udp500, 
                google_compute_forwarding_rule.europe_udp4500]
}

//Route for Europe to Asia
resource "google_compute_route" "europe_to_asia_route" {
  name                  = "europe-to-asia-route"
  network               = google_compute_network.europe-hq-network.id
  dest_range            = "192.168.33.0/24"
  next_hop_vpn_tunnel   = google_compute_vpn_tunnel.vpn_tunnel_europe_to_asia.id
}

//Forwarding Rules for Europe VPN
resource "google_compute_forwarding_rule" "europe_esp" {
  name          = "europe-esp"
  region        = "europe-west1"
  ip_protocol   = "ESP"
  ip_address    = google_compute_address.vpn_europe_ip.address
  target        = google_compute_vpn_gateway.vpn_gateway_europe.id
}

resource "google_compute_forwarding_rule" "europe_udp500" {
  name          = "europe-udp500"
  region        = "europe-west1"
  ip_protocol   = "UDP"
  port_range    = "500"
  ip_address    = google_compute_address.vpn_europe_ip.address
  target        = google_compute_vpn_gateway.vpn_gateway_europe.id
}

resource "google_compute_forwarding_rule" "europe_udp4500" {
  name          = "europe-udp4500"
  region        = "europe-west1"
  ip_protocol   = "UDP"
  port_range    = "4500"
  ip_address    = google_compute_address.vpn_europe_ip.address
  target        = google_compute_vpn_gateway.vpn_gateway_europe.id
}