## Architecture

The infrastructure follows a Zero Trust approach where internal systems are never directly exposed to external networks.

Administrative access is centralized through a hardened Bastion Host. The Bastion is the only machine reachable from the host computer, while internal servers remain isolated inside a private subnet.

The Bastion performs authentication, access control, and traffic filtering before allowing administrators to reach internal systems through SSH ProxyJump.

<p align="center">
  <img src="diagrams/zero-trust-diagram.drawio.png" alt="Infrastructure Overview" width="900">
</p>

### Architecture Overview

| Component | Role |
|-----------|------|
| Physical Host | Administrator workstation |
| VirtualBox NAT | Provides Internet access and SSH port forwarding |
| Ubuntu Bastion Host | Hardened entry point into the infrastructure |
| NAT Interface (`enp0s3`) | External connectivity |
| Internal Interface (`enp0s8`) | Secure communication with internal hosts |
| Kali Linux | Internal server accessible only through the Bastion |
