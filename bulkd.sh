#This script is written to delete the pods with specific status in the given namespace in the cluster.


#!/bin/bash

read -p "Namespace: " ns
read -p "Status of pods to be deleted :" status
kubectl get pods -n $ns | grep $status | awk '{print $1}' | xargs kubectl delete pod -n $ns
