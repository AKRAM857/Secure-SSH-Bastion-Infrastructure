#!/bin/bash

set -e

apt update
apt install -y fail2ban

systemctl enable fail2ban
systemctl restart fail2ban

echo "Fail2Ban installed successfully."
