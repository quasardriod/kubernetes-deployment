#!/bin/bash
NS="powerdns"
PORT_FORWARD=8088

kubectl apply -f ns-setup.yaml
[[ $? -ne 0 ]] && echo "Failed to create namespace" && exit 1

kubectl -n $NS apply -f db.yaml
[[ $? -ne 0 ]] && echo "Failed to create database" && exit 1

kubectl -n $NS apply -f powerdns-auth.yaml
[[ $? -ne 0 ]] && echo "Failed to create PowerDNS Auth" && exit 1

kubectl -n $NS apply -f powerdns-recursor.yaml
[[ $? -ne 0 ]] && echo "Failed to create PowerDNS Recursor" && exit 1

kubectl -n $NS apply -f powerdns-admin.yaml
[[ $? -ne 0 ]] && echo "Failed to create PowerDNS Admin" && exit 1

kubectl -n $NS run client --image=alpine:3.19 --restart=Never --command -- sleep 3600

# Port forwarding for PowerDNS Admin
#kubectl -n $NS port-forward svc/powerdns-admin $PORT_FORWARD:80 > /dev/null &
#echo "PowerDNS Admin is accessible at http://localhost:$PORT_FORWARD"
