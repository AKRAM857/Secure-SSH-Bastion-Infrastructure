#!/bin/bash

set -e

apt update
apt install -y openssh-server

systemctl enable ssh
systemctl start ssh

echo "OpenSSH Server installed successfully."
