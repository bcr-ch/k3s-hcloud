#!/bin/bash

if [ "$1" == "" ]; then
    echo "You need to specifiy a host!"
    return
fi

if [ "$2" == "" ]; then
	echo "You need to specify the Host Key"
	return
fi

ssh -t -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile /dev/null" -i $2 root@$1 'cloud-init status --wait'
scp -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile /dev/null" -i $2 root@$1:/etc/rancher/k3s/k3s.yaml ./kube_config.yaml
sed -i '' -e  's/127\.0\.0\.1/'$1'/g' ./kube_config.yaml
