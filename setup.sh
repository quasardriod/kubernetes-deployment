#!/bin/bash

set -e

source scripts/constant.sh
K8S_INVENTORY_FILE=inventory/k8s-inventory.yml
K8S_PLAYBOOK_FILE=ansible/playbooks/k8s-deployment.yml

function configure_privileges(){
    # Get ansible_user from inventory file
    ansible_user=$(ansible-inventory -i $K8S_INVENTORY_FILE --list|jq '._meta.hostvars[]|.ansible_user'|sort -u|tr -d '"')

    if [ -z "$ansible_user" ]; then
        error "ERROR: ansible_user not found in inventory file."
        exit 1
    fi

    if [ $(echo $ansible_user|wc -l) -gt 1 ]; then
        error "ERROR: Multiple ansible_user found in inventory file."
        exit 1
    fi
    # Set become option for ansible_user
    if [ $ansible_user != "root" ]; then
        ansible_extra_options="--become --become-user root --become-method sudo"
    else
        ansible_extra_options=""
    fi
}
function inventory_checks(){
    inventory=$1
    if [ ! -f $inventory ];then
        error "\nERROR: Inventory file: $inventory not found\n"
        exit 1
    fi
    
    # Check if the inventory file is valid
    if ! ansible-inventory -i $inventory --list > /dev/null 2>&1; then
        error "\nERROR: Invalid inventory file: $inventory\n"
        exit 1
    fi

    # Check connectivity to all hosts in the inventory
    if ! ansible all -i $inventory -m ping > /dev/null 2>&1; then
        error "\nERROR: Unable to connect to one or more hosts in the inventory\n"
        exit 1
    fi

    # Ensure master and worker groups are defined in the inventory
    # Fix it, do not run for minikube inventory
    if [[ "$inventory" == *"minikube"* ]]; then
        return
    fi
    if ! ansible-inventory -i $inventory --list | jq -e '.master' > /dev/null 2>&1; then
        error "ERROR: 'master' group not defined in the inventory file: $inventory\n"
        exit 1
    fi
    if ! ansible-inventory -i $inventory --list | jq -e '.worker' > /dev/null 2>&1; then
        error "ERROR: 'worker' group not defined in the inventory file: $inventory\n"
        exit 1
    fi
    success "Inventory file: $inventory is valid and all hosts are reachable."
}

# tools

function kubeadm_deployment(){
    # Query inventory for ansible_user, if ansible_user is not root,
    # set become option
    # configure_privileges

    inventory_checks $K8S_INVENTORY_FILE

    # Ensure master group is defined in the inventory and has one host
    master_hosts_count=$(ansible-inventory -i $K8S_INVENTORY_FILE --list -l master|jq '.master.hosts|length')
    if [ "$master_hosts_count" -ne 1 ]; then
        error "ERROR: The master group must have exactly one host."
        exit 1
    fi
    # Ensure worker group is defined in the inventory and has at least one host
    worker_hosts_count=$(ansible-inventory -i $K8S_INVENTORY_FILE --list -l worker|jq '.worker.hosts|length')
    if [ "$worker_hosts_count" -lt 1 ]; then
        error "ERROR: The worker group must have at least one host."
        exit 1
    fi

    ansible-playbook -i $K8S_INVENTORY_FILE $K8S_PLAYBOOK_FILE
}

function minikube_deployment(){
    local minikube_inventory=inventory/minikube-inventory.yml
    local pb=ansible/playbooks/minikube.yml

    inventory_checks $minikube_inventory

    ansible-playbook -i $minikube_inventory $pb
}

usage(){
    echo
    echo "Usage: $0 [options]"
    echo "Options:"
    echo " -d   Download kubeconfig on local machine"
    echo " -i   Configure Inventory file for the deployment"
    echo " -k   Deploy Kubernetes cluster using kubeadm"
    echo " -m   Deploy Kubernetes cluster using minikube"
    echo " -h   help, this message"
    echo " -t   Download kubernetes client tools, e.g. kubectl, helm, kustomize"
    echo
    exit 0
}


while getopts 'dhkmti' opt; do
    case $opt in
        d) download_kubeconfig;;
        i) inventory_checks;;
        k) kubeadm_deployment;;
        m) minikube_deployment;;
        t) k8s_tools;;
        h) usage;;

    esac
done

shift $((OPTIND - 1))
exit 0
