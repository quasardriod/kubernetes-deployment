#!/bin/bash

if kubectl -n kube-system get daemonset.apps/calico-node > /dev/null 2>&1;then
    daemonset=$(kubectl -n kube-system get daemonset.apps/calico-node|egrep -v NAME)

    dset_desired=$(echo $daemonset|awk '{print $2}')
    dset_available=$(echo $daemonset|awk '{print $6}')

    if [ $dset_desired == $dset_available ];then
        dset_health=healthy
    fi

else
    echo "calico not found" && exit 0
fi

if kubectl -n kube-system get deployment.apps/calico-kube-controllers > /dev/null 2>&1;then

    deployment=$(kubectl -n kube-system get deployment.apps/calico-kube-controllers|egrep -v NAME)
    if [ "$(echo $deployment|awk '{print $2}')" == "1/1" ];then
        deployment_health=healthy
    fi
else
    echo "calico not found" && exit 0
fi

if [ $dset_health == "healthy" ] && [ $deployment_health == "healthy" ];then
    echo "calico is healthy"
else
    echo "calico is unhealthy: deamonset health-> $dset_health and deployment health-> $deployment_health"
fi