#!/bin/bash
dt=$(date "+%d-%m-%y-%H-%M")
mkdir MOH_$dt
echo "Created folder named MOH_$dt"
read -p "Enter Distribution name :" dist

file=`ls ~/Downloads | grep $dist`

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
        #noe=$(awk '$9 ~ /^4[0-9][0-9]$/ { count++ } END { print count }' $uz)
        #noe=$(grep -o '\s4[0-9]{2}\s' $uz | wc -l)
        #echo "Totol number of 4xx errors found = $noe"
        #echo "--------------------------------------------------------------------------------------------------------------"
        grep --color -E '400|401|402|403|404|405|500|501|502|503|504|505|506|507|508|509|510|511' ~/Downloads/MOH_$dt/$uz
	#cat $uz | awk '{print $9}' |  grep -E '40[0-5]' | wc -l
        noe=$(grep --color -E '400|401|402|403|404|405' ~/Downloads/MOH_$dt/$uz | awk '{print $9}' | grep '40[0-5]' | wc -l)
        noe1=$(grep --color -E '500|501|502|503|504|505|506|507|508|509|510|511' ~/Downloads/MOH_$dt/$uz | awk '{print $9}' | grep '5[0-1][0-9]' | wc -l)
	#echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	#echo " "
	echo  "\033[1;31mTotal number of 4XX errors in $uz are $noe\033[0m"
        echo  "\033[1;31mTotal number of 5XX errors in $uz are $noe1\033[0m"
	#echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        #echo "--------------------------------------------------------------------------------------------------------------"
	#echo " "
done
