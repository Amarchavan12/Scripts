#!/bin/bash

if [ -z "$1" ];
then
    echo "Please rerun the script with following syntax"
    echo "sh node-high.sh <name-name>"
else

    # Obtain the name of vcluster to derive the context from it
    vcluster=$(kubectl get nodes -L eks.amazonaws.com/capacityType,topology.kubernetes.io/zone,node.kubernetes.io/instance-type,TENANT-NAME | awk '{ print $9 }' | tail -1)

    # Obtain the context
    context=$(kubectl config get-contexts | grep $vcluster | awk '{ print $2 }')

    #cluster=$(loft list vclusters | grep $vcluster | awk '{ print $3 }')

    # Obtain the name of parent-cluster
    cluster=$(kubectl config current-context | rev | cut -c 1-18 | rev)

    # Connect to the parent cluster
    loft use cluster $cluster

    # cordon the given node
    kubectl cordon $1

    # switch back to the vcluster
    kubectl config use-context $context

    # Describe the cordoned node
    #kubectl describe node $1
    sum=$(kubectl describe node $1 | grep "Non-terminated Pods" | grep -oE '\d+')
    kubectl describe node $1 | grep -A $(($sum + 2)) "Non-terminated Pods"
    
    echo "--------------------------------------------------------------------------------------------------------------------------------"
    echo "Daemonsets: "
    echo "--------------------------------------------------------------------------------------------------------------------------------"
    Kubectl get ds -A
    echo "--------------------------------------------------------------------------------------------------------------------------------"

      # Provide the numaric count of pods to be deleted
    
    echo " *** Please do not delete any pod that belongs to above daemonsets  ***"
    echo " "

    # Provide the numaric count of pods to be deleted
    read -p "How many pods needs to be deleted (provide numaric count): " count
    
    # The for loop will execute number of times equal to "count" provided. 
    for ((i=1; i<= $count; i++))
    do
        read -p "Please specify the name of pod that needs to be deleted : " pd
        read -p "Please provide Namespace of the pod : " ns
        kubectl delete pod $pd -n $ns
    done

    # Switch again to parent-cluster to uncordon the node
    loft use cluster $cluster

    # uncordon the given node
    kubectl uncordon $1

    # switch back to the vcluster
    kubectl config use-context $context

fi
