#!/bin/bash
dt=$(date "+%d-%m-%y-%H-%M")
mkdir MOH_$dt
echo "Created folder named MOH_$dt"
file=`ls ~/Downloads | grep E1T8KKX7YJPZKB`

for i in $file
do
	mv ~/Downloads/$i ~/Downloads/MOH_$dt 
	gzip -d ~/Downloads/MOH_$dt/$i
 	echo "--------------------------------------------------------------------------------------------------------------"
 	echo "File name: $i"
 	echo "--------------------------------------------------------------------------------------------------------------"

#	cat ~/Downloads/MOH_$dt/$i | grep --color -E '404'
	uz=$(expr " $i" : ' \(.*\)...')
#	uz=$(echo "$i" | cut -c -37)
 	grep --color -E '404|403' ~/Downloads/MOH_$dt/$uz
done
