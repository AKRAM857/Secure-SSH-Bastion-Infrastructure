# SSH Authentication Flow

## Overview

This diagram illustrates the SSH authentication process implemented in this project.

Rather than exposing the internal server directly to the network, all administrative access is centralized through a hardened Bastion Host. The administrator authenticates using public-key cryptography, and SSH ProxyJump transparently forwards the connection to the internal server.

This approach minimizes the attack surface while ensuring that every SSH connection is individually authenticated.

---


## Authentication Process

1. The administrator initiates an SSH connection from the local workstation.

2. The SSH client uses the local private key (`id_ed25519`) to sign the authentication challenge. The private key never leaves the administrator's machine.

3. The Bastion Host verifies the signature using the corresponding public key stored in the `authorized_keys` file.

4. After successful authentication, SSH ProxyJump automatically establishes a second SSH connection from the Bastion Host to the internal server.

5. The internal server performs the same public-key authentication process by verifying the client's public key stored in its own `authorized_keys` file.

6. Once authentication succeeds on both systems, an interactive SSH session with the internal server is established.

---

## Components

| Component | Description |
|-----------|-------------|
| SSH Client | Initiates the SSH connection from the administrator's workstation. |
| Private Key (`id_ed25519`) | Proves the administrator's identity. It always remains on the local machine. |
| Bastion Host | The only server exposed for administrative access. It authenticates users and securely forwards connections. |
| Internal Server | Private server accessible only through the Bastion Host. |
| `authorized_keys` | Stores trusted public keys used to verify client identities. |

---

## Security Considerations

The implemented authentication model follows several Zero Trust principles:

- No direct SSH access to internal systems.
- Public-key authentication instead of passwords.
- Private keys never leave the administrator's workstation.
- Every server performs its own authentication independently.
- Administrative access is centralized through a hardened Bastion Host.

---

## Engineering Notes

Although the SSH connection passes through the Bastion Host, authentication is **not** delegated. Both the Bastion Host and the internal server independently verify the administrator's identity using their own `authorized_keys` file.

This ensures that every system explicitly validates the user's identity before granting access, providing defense in depth and reducing the risk of unauthorized lateral movement within the infrastructure.
