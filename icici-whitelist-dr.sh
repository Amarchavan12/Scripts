#!/bin/bash

# Set your project ID
PROJECT_ID="just-student-350007"
gcloud config set project $PROJECT ID

#List of VPCs to check
VPCS-("ibdi-gpay-dmz-out-untrust-vpc01" "ibdi-gpay-dmz-untrust-vpc01" "ibdi-gpay-dmz-out-trust-vpc01")

# IP to be removed
read -p "Enter The IP address to be removed from firewall rule: IP TO REMOVE

#IP TO REMOVE="104.223.91.19"

#Function to remove IP from a firewall rule
remove_ip_from_firewall() {
	local firewall_name=$1
	local source_ranges=$2
# Convert colon-separated source ranges to comma-separated 
	source_ranges_comma=$(echo "$source_ranges" | tr';'',')
	echo "Backing up source ranges for firewall rule '$firewall_name'" echo "$source_ranges_comma" > "${firewall name) backup.txt"
# Remove the IP from the source ranges
	new_source_ranges=""
	for range in $(echo "$source_ranges_comma" | tr',''); do 
		if [ "$range" != "$IP_TO_REMOVE" ]; then 
			if [ -z "$new_source_ranges" ]; then 
				new_source_ranges="$range"
			else
				new_source_ranges="$new_source_ranges, $range"
			fi
		fi
	done
# Update the firewall rule with the new source ranges echo "Updating firewall rule '$firewall_name"
gcloud compute firewall-rules update "$firewall name" \
--project="$PROJECT_ID" \
--source-ranges="$new_source_ranges"
echo "Firewall rule '$firewall_name updated successfully"
}

# Iterate over each VPC
for vpc in "${VPCS[@]}"; do
	echo " "
	echo "Checking VPC: $vpc"
	echo " "

# List all firewall rules in the project
	gcloud compute firewall-rules list --project="$PROJECT_ID" --format="csv[no-heading] (name, network, sourceRanges)" | while IFS-, read -r firewall_name networksource_ranges; do
# Check if the firewall is in the current VPC
	if [ "$network" == "$vpc"]]; then
		for range in $(echo "$source_ranges" | tr';'); do 
			if [ "$range" "$IP_TO_REMOVE"* ]]; then
				echo "Firewall rule '$firewall_name' contains the IP $IP_TO_REMOVE"
				remove_ip_from_firewall "$firewall_name" "$source_ranges"
				break
			fi
		done

	fi
done
done
