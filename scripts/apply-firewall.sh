#!/bin/bash

set -e

nft flush ruleset
nft -f /etc/nftables.conf

systemctl restart nftables

echo "Firewall applied."
