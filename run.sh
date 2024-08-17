#!/bin/bash

function tools(){
    if ! which git > /dev/null 2>&1;then
        sudo dnf install git curl -y -q
    fi

    if ! which ansible > /dev/null 2>&1;then
        sudo dnf install ansible-core -y -q
    fi

    if ! which kubectl > /dev/null 2>&1;then
        curl -LO -s "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install kubectl /usr/local/bin
    fi

    if [ ! -f /usr/bin/kubectl ];then
        sudo ln -s /usr/local/bin/kubectl /usr/bin/kubectl
    fi
}

tools

[ -z $1 ] && error "\nERROR: Provide inventory file in 1st argument\n" && exit 1
if [ ! -f $1 ];then
    error "\nERROR: Inventory file: $1 not found\n"
    exit 1
fi

MACHINES_INVENTORY=$1
PB_DIR=playbooks


function k8s_deployment(){
    ansible-playbook -i $MACHINES_INVENTORY $PB_DIR/k8s-deployment.yml
}

k8s_deployment

