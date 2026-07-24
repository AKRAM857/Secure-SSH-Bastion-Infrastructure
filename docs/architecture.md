# Infrastructure Architecture

## Overview

The infrastructure is designed around the principle that internal systems should never be directly exposed to external networks.

Instead of allowing administrators to connect directly to the target server, all remote administrative access is centralized through a dedicated Bastion Host. The Bastion acts as the only trusted entry point into the environment, enforcing authentication before any connection is allowed to reach internal systems.

This architecture applies fundamental Zero Trust principles by reducing the attack surface, isolating internal resources, and ensuring that every administrative connection is explicitly authenticated.

---

## Architecture Diagram



<p align="center">

  <img src="../diagrams/architecture.png"
 alt="Infrastructure Overview"
width="900"> 
</p>


## Architecture Components

| Component | Role |
|-----------|------|
| **Developer Workstation** | The administrator's computer used to manage the infrastructure through SSH. |
| **VirtualBox NAT** | Provides Internet connectivity for the virtual machines and forwards SSH traffic from the host to the Bastion Host. |
| **Ubuntu Bastion Host** | The only system exposed for remote administration. It authenticates administrators and securely forwards SSH sessions to internal systems using ProxyJump. |
| **External Interface (`enp0s3`)** | Connects the Bastion Host to the VirtualBox NAT network. |
| **Internal Interface (`enp0s8`)** | Connects the Bastion Host to the protected internal network. |
| **Protected Network** | Private network containing systems that are intentionally inaccessible from external networks. |
| **Kali Linux Server** | Internal machine used for administration and security testing. It can only be reached through the Bastion Host. |

---

## Network Design

The Bastion Host is equipped with two network interfaces, allowing it to operate as the boundary between two separate security zones.

The external interface provides connectivity to the VirtualBox NAT network, making the Bastion the only machine reachable from the host computer. The internal interface connects to the protected network, where administrative systems remain isolated from direct external access.

This separation ensures that internal hosts are never exposed to incoming connections while still allowing authorized administrators to securely access them through the Bastion.

---

## Security Model

The architecture follows several core security principles:

- The Bastion Host is the only externally reachable system.
- Internal servers are isolated within a private network.
- Administrative access is performed exclusively through SSH.
- Public-key authentication is used instead of passwords.
- SSH ProxyJump provides secure access to internal systems without exposing them directly.
- Network segmentation limits the exposure of critical infrastructure.

Rather than relying on perimeter security alone, every administrative connection must first authenticate with the Bastion Host before reaching the protected environment.

---

## Engineering Decisions

Several design decisions were made during the implementation of this environment:

- Ubuntu Server was selected as the Bastion operating system because of its stability and extensive documentation.
- The Bastion Host uses two network interfaces to separate external connectivity from the protected internal network.
- VirtualBox NAT was used to emulate Internet connectivity while keeping the lab isolated from the physical network.
- SSH ProxyJump was chosen to simplify secure multi-hop administration without exposing internal systems.
- The infrastructure was intentionally built from individual Linux components to better understand how routing, authentication, and access control interact.

These choices prioritize understanding the underlying technologies rather than relying on preconfigured security appliances.

---

## Next Steps

This architecture establishes the foundation for additional security controls that will be introduced in future iterations of the project, including:

- Firewall enforcement using **nftables**
- SSH service hardening
- Fail2Ban integration
- Centralized security monitoring
- Multi-factor authentication
- VPN-based administrative access

Each enhancement builds upon the same Zero Trust architecture while maintaining the principle that internal systems should never be directly exposed.
