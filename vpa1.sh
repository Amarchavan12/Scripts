#!/bin/bash

# Generate unique file name using current date and time
output_file="vpa_ids_$(date +'%Y%m%d_%H%M').csv"

# Temporary storage for valid VPAs
valid_vpas=()

# Function to validate VPA
validate_vpa() {
    local vpa=$1
    if [[ $vpa == *@okaxis ]]; then
        return 0  # Valid VPA
    else
        return 1  # Invalid VPA
    fi
}

# Loop to take user input
while true; do
    read -p "Enter a VPA ID (or type 'exit' to quit): " vpa_id

    if [[ $vpa_id == "exit" ]]; then
        if [[ ${#valid_vpas[@]} -eq 0 ]]; then
            echo "No valid VPAs entered. No CSV file will be created."
        else
            # Create the CSV file and add the column heading
            echo "Payer_VPA" > "/Users/amarchavan/Downloads/vpa/$output_file"

            # Add valid VPAs to the file
            for vpa in "${valid_vpas[@]}"; do
                echo "$vpa" >> "/Users/amarchavan/Downloads/vpa/$output_file"
            done

            echo "CSV file created at /Users/amarchavan/Downloads/vpa/$output_file location"
        fi
        break
    fi

    # Validate and store VPA if valid
    if validate_vpa "$vpa_id"; then
        valid_vpas+=("$vpa_id")
        echo "VPA added."
    else
        echo "Invalid VPA! The VPA must end with '@okaxis'."
    fi
done
