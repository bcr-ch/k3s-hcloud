#!/bin/bash

export DEBIAN_FRONTEND=noninteractive ; sudo apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes

# Installing and enabling fail2ban
sudo apt-get install -y fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Initializing Master
curl -sfL https://get.k3s.io | K3S_TOKEN=${secret} \
    sh -s - server --token=${secret} --server https://${leader_ip}:6443 --disable=traefik,local-storage,servicelb --kubelet-arg="cloud-provider=external" --disable-cloud-controller 
