# Multi-Region GCP Enterprise Networking and Compute Deployment Project

This Terraform project is a <b>multi-region cloud infrastructure deployment</b> in Google Cloud Platform that simulates a globally distributed enterprise environment across Europe, the Americas, and Asia. 
<br> 

It demonstrates advanced Infrastructure as Code (IaC) concepts including:
  - Multi-region VPC architecture
  - Custom networking and subnet segmentation
  - Linux and Windows VM deployments
  - Firewall rule management
  - Cross-region VPC peering
  - Site-to-site VPN connectivity
  - Secret Manager integration
  - Automated web server provisioning
  - Secure cloud networking design

This is significantly more advanced than a basic VM deployment because it models a real-world enterprise hybrid/global network topology.

#

### High-Level Purpose of the Terraform Project
The script provisions:

#### Europe (HQ Environment)
  - Dedicated VPC network
  - Regional subnet
  - Linux VM running Apache web server
  - Firewall rules allowing HTTP traffic
  - VPN gateway for secure communication
This acts as the “headquarters” network.
<br>

#### Americas Environment
  - Separate VPC network
  - Multiple regional subnets
  - Multiple Linux VM instances
  - Public access configuration
  - HTTP and SSH firewall access
This simulates branch office or regional infrastructure.
<br>

#### Asia Environment
  - Separate VPC network
  - Windows Server VM
  - RDP firewall access
  - VPN gateway
  - Secure routing to Europe HQ
This simulates another geographically isolated office/datacenter.
<br>

#### Secure Cross-Region Connectivity
The project establishes:
  - VPC Network Peering between Asia and Europe
  - IPSec VPN tunnels between Europe and Asia
  - Static routes for private communication
  - Secure secret retrieval using Secret Manager
This enables private inter-network communication across regions.

#

### What This Project Demonstrates Technically
This project demonstrates strong skills in:

#### Cloud Engineering
  - Google Cloud networking
  - Compute Engine provisioning
  - Hybrid/multi-region architecture
  - VPN networking
<br>

#### DevOps / Infrastructure as Code
  - Terraform resource orchestration
  - Dependency management
  - Modular infrastructure concepts
  - Automated provisioning
<br>

#### Networking
  - CIDR planning
  - Subnet segmentation
  - VPC peering
  - VPN tunnels
  - Routing tables
  - Firewall security rules
<br>

#### Systems Administration
  - Linux automation
  - Apache installation via startup scripts
  - Windows Server deployment
  - Public/private networking

#

### Major Architectural Components Explained

### 1. Provider Configuration
````
terraform {
 required_providers {
   google = {
     source  = "hashicorp/google"
     version = "5.28.0"
   }
 }
}
````

#### Purpose
Defines:
  - Terraform Google provider
  - Provider source
  - Version pinning for consistency

#### Resume Relevance
Shows:
  - Terraform dependency management
  - Reproducible infrastructure deployments
<br>

### 2. Europe HQ Network
````
resource "google_compute_network" "europe-hq-network"
````

#### Purpose
Creates a dedicated VPC network for the Europe headquarters environment.
<br>
#### Important Design Choice
````
auto_create_subnetworks = false
````
<br>

This means:
- Manual subnet control
- Custom enterprise networking
- Avoids default subnet sprawl

This is considered a professional networking practice.
<br>

### 3. Europe Subnet
```
resource "google_compute_subnetwork" "europe-hq-subnet"
```

#### Purpose
Creates a private subnet:
  - Region: Europe West
  - CIDR: 10.180.30.0/24
Used for:
  - VM placement
  - Network segmentation
  - IP organization
<br>

### 4. Europe HQ VM
````
resource "google_compute_instance" "europe-hq-vm"
````

#### Purpose
Deploys a Debian Linux VM acting as:
  - Web server
  - HQ application server
  - Internal services node

#### Startup Script Automation
````
apt update
apt install -y apache2
````

Automatically:
  - Updates packages
  - Installs Apache
  - Creates custom HTML page
This demonstrates:
  - Bootstrapping
  - Immutable infrastructure concepts
  - Automated server configuration

### 5. Americas Infrastructure
Creates:
  - Separate VPC
  - Multiple subnets
  - Multiple VMs
This demonstrates:
  - Regional isolation
  - Distributed infrastructure
  - Scalable architecture
<br>

### 6. Asia Infrastructure
Creates:
  - Asia VPC
  - Windows Server 2022 VM
  - RDP access
This demonstrates:
  - Cross-platform administration
  - Windows cloud deployments
  - Mixed OS enterprise environments
<br>

### 7. Firewall Rules
Examples:
````
resource "google_compute_firewall" "allow_rdp_asia"
````
#### Purpose
Controls inbound traffic.
Rules allow:
  - HTTP
  - SSH
  - RDP
This demonstrates:
  - Network security
  - Access control
  - Cloud firewall management
<br>

### 8. VPC Peering
````
resource "google_compute_network_peering"
````
#### Purpose
Allows private communication between:
  - Europe network
  - Asia network
Without using public internet.
<br>

Demonstrates:
  - Enterprise networking
  - Low-latency communication
  - Private routing
<br>

### 9. VPN Infrastructure
This is one of the strongest parts of the project.
<br>
Resources include:
  - VPN gateways
  - External IPs
  - VPN tunnels
  - Forwarding rules
  - Routes

#### VPN Tunnel Purpose
````
resource "google_compute_vpn_tunnel"
````
<br>

Creates encrypted IPSec tunnels between:
  - Europe HQ
  - Asia network

This simulates:
  - Hybrid cloud
  - Secure branch office connectivity
  - Enterprise WAN architecture
<br>

### 10. Secret Manager Integration
````
data "google_secret_manager_secret_version"
````
#### Purpose
Securely retrieves VPN shared secrets.
<br>
This demonstrates:
  - Secure credential handling
  - Secret management best practices
  - Avoiding hardcoded secrets
This is an excellent DevOps/security practice.
<br>

### 11. Outputs
Outputs expose:
  - VPN public IPs
  - VM internal IPs
Useful for:
  - Automation
  - CI/CD pipelines
  - Infrastructure integration


Windows Server deployment
Public/private networking
