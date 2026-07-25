#!/bin/bash

set -e

echo "[*] Saving current nftables rules..."

nft list ruleset > /etc/nftables.conf

echo "[+] Rules saved to /etc/nftables.conf"
