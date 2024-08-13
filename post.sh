#!/bin/bash

# Function to post a message
post_message() {
    local message=$1
    curl -X POST -H "Content-Type: application/json" -H "Authorization: $AUTH_KEY" --insecure -d "{\"message\": \"$message\"}" "$API_URL/hello/post"
}

# Prompt user for API URL and authorization key
read -p "Enter the API URL (e.g., https://4.246.228.175:8005): " API_URL
read -p "Enter the Authorization key: " AUTH_KEY

# Loop to get user input for messages
while true; do
    read -p "Enter a message to post (or type 'exit' to quit): " user_input

    if [[ "$user_input" == "exit" ]]; then
        break
    fi

    post_message "$user_input"
done

echo "All messages posted."
