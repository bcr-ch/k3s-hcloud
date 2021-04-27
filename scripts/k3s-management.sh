#!/bin/bash

export DEBIAN_FRONTEND=noninteractive 
apt-get update
apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes

# Installing and enabling fail2ban
apt-get install -y fail2ban
systemctl start fail2ban
systemctl enable fail2ban

INTERNALIP=`ip -br a | grep ens10 | awk '{ print $3 }' | awk -F\/ '{print $1}'`

# Initializing Master
curl -sfL https://get.k3s.io | K3S_TOKEN=${secret} \
    sh -s - server --cluster-init --token=${secret} --disable=traefik,local-storage,servicelb --kubelet-arg="cloud-provider=external" --disable-cloud-controller --tls-san ${lb_ip} -i $INTERNALIP --node-external-ip $INTERNALIP --flannel-iface ens10 
