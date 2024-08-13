#!/bin/bash

# Function to URL-encode the message
urlencode() {
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
}

# Function to delete a message
delete_message() {
    local message=$(urlencode "$1")
    curl -X DELETE -H "Authorization: $AUTH_KEY" --insecure "$API_URL/hello/$message"
}

# Prompt user for API URL and authorization key
read -p "Enter the API URL (e.g., https://4.246.228.175:8005): " API_URL
read -p "Enter the Authorization key: " AUTH_KEY

# Loop to get user input for messages to delete
while true; do
    read -p "Enter the message to delete (or type 'exit' to quit): " user_input

    if [[ "$user_input" == "exit" ]]; then
        break
    fi

    delete_message "$user_input"
done

echo "All specified messages deleted."
