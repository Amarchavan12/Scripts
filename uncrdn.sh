#!/bin/bash

vcluster=$(kubectl get nodes -L eks.amazonaws.com/capacityType,topology.kubernetes.io/zone,node.kubernetes.io/instance-type,TENANT-NAME | awk '{ print $9 }' | tail -1)
context=$(kubectl config get-contexts | grep $vcluster | awk '{ print $2 }')
#cluster=$(loft list vclusters | grep $vcluster | awk '{ print $3 }')
cluster=$(kubectl config current-context | rev | cut -c 1-18 | rev)
loft use cluster $cluster
#kubectl uncordon $1
kubectl config use-context $context
