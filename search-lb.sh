#!/bin/bash
for project in paisa-pocvm hfc-housing-finance indiainfoline-new-website indiainfolinewebsite-208612 nbfc-homeloans nbfc-geocodingapi
do
        gcloud config set project $project 2>/dev/null
        url=na
        lb=$(gcloud compute url-maps list | awk '{print $1}') 2>/dev/null
        for i in $lb
        do
            url=$(gcloud compute url-maps describe $i | grep -i $1 ) 2>/dev/null
           # echo $i  $url
                if [ -n "$url" ]; then                    
                   echo "-------------------------------------------------------------"
                    echo  "\033[5;31m ** URL Match Found ** \033[0m"
                   echo "-------------------------------------------------------------"
                    echo  "Name of Project:\033[4;32m $project \033[0m"
                    echo  "Name of LB:\033[4;32m $i \033[0m"
                    echo  "URL Matched:\033[4;32m$url \033[0m"
                   echo "-------------------------------------------------------------"
                   echo " "
                    
                fi
       done
done
