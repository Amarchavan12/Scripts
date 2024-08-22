#!/bin/bash

# Ensure AWS CLI is installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI not found. Please install it before running this script."
    exit 1
fi

# Function to print usage
usage() {
    echo "Usage: $0"
    echo "You will be prompted to enter the Lambda function name and end time."
    exit 1
}

# Collect input from user
read -p "Enter the AWS Lambda function name: " FUNCTION_NAME
read -p "Enter the end time (e.g., 18 July, 2024 21:59:18): " END_TIME_INPUT

# Validate input
if [ -z "$FUNCTION_NAME" ] || [ -z "$END_TIME_INPUT" ]; then
    echo "All inputs are required."
    usage
fi

# Convert end time to Unix timestamp
END_TIMESTAMP=$(date -d "$(echo $END_TIME_INPUT | sed 's/,//')" +%s)
if [ $? -ne 0 ]; then
    echo "Invalid end time format."
    exit 1
fi

# Calculate start time as 5 minutes prior to end time
START_TIMESTAMP=$((END_TIMESTAMP - 300))

# Convert timestamps back to RFC3339 format
START_TIME=$(date -u -d "@$START_TIMESTAMP" +"%Y-%m-%dT%H:%M:%SZ")
END_TIME=$(date -u -d "@$END_TIMESTAMP" +"%Y-%m-%dT%H:%M:%SZ")

# Generate output file name based on current date and time
OUTPUT_FILE="lambda_logs_$(date +"%Y%m%d_%H%M%S").txt"

# Get the log group name for the Lambda function
LOG_GROUP_NAME="/aws/lambda/$FUNCTION_NAME"

# Collect logs
echo "Collecting logs for Lambda function '$FUNCTION_NAME' from '$START_TIME' to '$END_TIME'..."
aws logs filter-log-events --log-group-name "$LOG_GROUP_NAME" --start-time "$((START_TIMESTAMP * 1000))" --end-time "$((END_TIMESTAMP * 1000))" --query 'events[*].message' --output text > "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    FULL_PATH=$(realpath "$OUTPUT_FILE")
    echo "Logs successfully saved to $FULL_PATH"
else
    echo "Failed to collect logs"
    exit 1
fi