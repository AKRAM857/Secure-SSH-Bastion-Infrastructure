#!/bin/bash

set -e

echo "[*] Installing nftables configuration..."

cp ../configs/nftables/nftables.conf /etc/nftables.conf

systemctl enable nftables
systemctl restart nftables

echo "[+] nftables configuration deployed successfully."
