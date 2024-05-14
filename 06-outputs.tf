//Outputs
output "vpn_europe_ip" {
    value = google_compute_address.vpn_europe_ip.address
}

output "vpn_asia_ip" {
    value = google_compute_address.vpn_asia_ip.address
}

output "europe_vm_internal_ip" {
    description = "Internal IP address of the Europe HQ VM"
    value = google_compute_instance.europe-hq-vm.network_interface[0].network_ip
}