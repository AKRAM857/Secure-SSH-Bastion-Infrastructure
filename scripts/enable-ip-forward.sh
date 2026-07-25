#!/bin/bash

set -e

sysctl -w net.ipv4.ip_forward=1

grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf || \
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

sysctl -p

echo "IP forwarding enabled."
