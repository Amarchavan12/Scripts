#!/bin/bash

ns=$(kubectl get ns)
for NAMESPACE in $ns
do
# Get a list of pods that are not in the "Running" state
NON_RUNNING_PODS=$(kubectl get pods -n $NAMESPACE --field-selector=status.phase!=Running -o jsonpath='{.items[*].metadata.name}')
if [ -n "$NON_RUNNING_PODS" ]; then
	echo "Pods not in the 'Running' state in $NAMESPACE namespace:"
	echo "$NON_RUNNING_PODS"
	echo "-------------------------------------------------------------"

fi

done
