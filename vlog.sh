#!/bin/bash
dtm=$(date +'%d-%m-%y-%H-%M')
clstr=$(kubectl get ing -A | awk '{print $4}' | tail -1 | sed 's/.atlan.com//')
mkdir $clstr-$dtm
#cd $clstr_$dtm
vlt=$(kubectl get pods -n vault | tail -3 | awk '{print $1}')
#echo $vlt
for i in $vlt
do
	kubectl logs $i -n vault -c vault > /Users/amarchavan/$clstr-$dtm/$i.txt
done
