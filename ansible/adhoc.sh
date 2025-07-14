#!/bin/bash

echo "🔍 Checking Docker version on worker..."
ansible worker -i inventory.ini -m shell -a "docker --version" --become --extra-vars "ansible_become_pass=$1"

echo "🔍 Checking Kubernetes services on worker..."
ansible worker -i inventory.ini -m shell -a "KUBECONFIG=/home/[worker user name]/k3s.yaml kubectl get svc" --become --extra-vars "ansible_become_pass=$1"

