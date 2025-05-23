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

function error(){
    echo -e "\e[31m$1\e[0m"
}
function success(){
    echo -e "\e[32m$1\e[0m"
}
function info(){
    echo -e "\e[34m$1\e[0m"
}
function warning(){
    echo -e "\e[33m$1\e[0m"
}
function debug(){
    echo -e "\e[35m$1\e[0m"
}
function notice(){
    echo -e "\e[36m$1\e[0m"
}

function download_kubeconfig(){
    pb_download_kubeconfig=playbooks/adhoc/download-kubeconfig.yml
    inventory=$1
    if [ ! -f $inventory ];then
        error "\nERROR: Inventory file: $inventory not found\n"
        exit 1
    fi

    ansible-playbook -i $inventory $pb_download_kubeconfig
}

function install_kubectl(){
    notice "\nInstalling kubectl"
    notice "--------------------\n"
    if ! which kubectl > /dev/null 2>&1;then
        curl -LO -s "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install kubectl /usr/local/bin
    fi
    if [ ! -f /usr/bin/kubectl ];then
        sudo ln -s /usr/local/bin/kubectl /usr/bin/kubectl
    fi

}

function install_helm(){
    notice "\nInstalling helm"
    notice "--------------------\n"

    if ! which helm > /dev/null 2>&1;then
        curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
    fi
    if [ ! -f /usr/local/bin/helm ];then
        curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
    fi
    
    if [ ! -f /usr/bin/helm ];then
        sudo ln -s /usr/local/bin/helm /usr/bin/helm
    fi
}

function install_kustomize(){
    notice "\nInstalling kustomize"
    notice "--------------------\n"

    if ! which kustomize > /dev/null 2>&1;then
        curl -LO -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install.sh" -o /tmp/install.sh
        chmod +x /tmp/install.sh
        ./tmp/install.sh
        sudo install kustomize /usr/local/bin
        rm -f /tmp/install.sh
    fi
    if [ ! -f /usr/bin/kustomize ];then
        sudo ln -s /usr/local/bin/kustomize /usr/bin/kustomize
    fi
}   
function k8s_tools(){
    # install openssl on localhost
    if ! which openssl > /dev/null 2>&1;then
        if ansible localhost -m setup -a "filter=os_family" | grep -q "RedHat"; then
            sudo dnf install openssl -y -q
        elif ansible localhost -m setup -a "filter=os_family" | grep -q "Debian"; then
            sudo apt-get install openssl -y -q
        else
            error "ERROR: Unsupported OS. Please install openssl manually."
            exit 1
        fi
    fi
    install_kubectl
    install_helm
    # install_kustomize
}