## Architecture Diagram

<p align="center">
  <img src="../diagrams/architecture.png" alt="Infrastructure Overview" width="900">
</p>

## Architecture Components

| Component | Role |
|-----------|------|
| **Physical Host (Developer's Laptop)** | The administrator's workstation. Initiates all SSH connections into the infrastructure through port forwarding. |
| **VirtualBox NAT** | Simulates an internet gateway. Forwards SSH connections from the physical host to the Bastion Host via port forwarding (2222 → 22). Also provides internet access for the Bastion so internal servers can pull updates through it. |
| **Bastion Server (Ubuntu)** | The only machine reachable from outside. Authenticates every connection and forwards authorized sessions to the internal server via SSH ProxyJump. Equipped with two network interfaces — one facing the exposed network, one facing the internal network. |
| **Exposed Network** | The network segment where the Bastion's external interface lives. Reachable from the physical host through VirtualBox NAT. |
| **Internal Network** | A fully isolated private network. No machine here is reachable from outside — the only path in is through the Bastion. |
| **Server 1 (Kali Linux)** | Internal server sitting inside the protected network. Reachable exclusively through the Bastion via ProxyJump. Never exposed to external connections directly. |

---

## Network Design

The Bastion Host has two network interfaces that place it at the boundary between two separate network zones.

The external interface (`enp0s3`) connects to the exposed network, making the Bastion the only machine the physical host can reach. The internal interface (`enp0s8`) connects to the protected internal network where Server 1 lives.

Traffic flows in two directions through this design:

- **Inbound SSH** — The physical host connects to `localhost:2222`, VirtualBox NAT forwards it to the Bastion on port 22. The Bastion authenticates the connection and uses ProxyJump to transparently tunnel it through to Server 1 on the internal network.
- **Outbound updates** — Server 1 cannot reach the internet directly. Update requests travel from Server 1 through the Bastion's internal interface, out through the external interface, and through VirtualBox NAT to the internet. The Bastion performs NAT masquerading so responses return correctly.

This separation guarantees that Server 1 is never directly exposed. There is no route to it except through the Bastion.

---

## Security Model

- The Bastion is the only externally reachable machine — everything else is behind it
- Public-key cryptography replaces passwords entirely — no password authentication exists on any machine
- SSH ProxyJump creates a transparent encrypted tunnel through the Bastion to internal servers — the Bastion never sees credentials for the internal server
- The private key never leaves the physical host — the Bastion is a blind pipe, not a credential store
- Network segmentation enforces isolation at the infrastructure level — not just at the software level

---

## Engineering Decisions

- **Two-interface Bastion design** — separating external and internal connectivity enforces network-level isolation. An attacker who reaches the exposed network cannot reach the internal network without passing through the Bastion's authentication and firewall layers.
- **VirtualBox NAT as internet gateway** — simulates the role of an AWS Internet Gateway or ISP router. The Bastion acts as the NAT router for internal servers, mirroring the production pattern where private subnet machines route outbound traffic through a gateway.
- **Port forwarding 2222 → 22** — simulates a public IP on the Bastion. In a real cloud deployment, an Elastic IP would be assigned directly to the Bastion's external interface. The security model is identical — only the addressing mechanism differs.
- **ProxyJump over manual multi-hop** — using `-J` keeps the private key on the physical host at all times. A compromised Bastion gains no credentials for internal servers because the authentication challenge is forwarded back to the client to solve locally.
