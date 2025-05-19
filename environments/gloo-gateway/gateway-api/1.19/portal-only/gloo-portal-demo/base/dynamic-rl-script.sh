#!/bin/bash

# Step 1: Set the user and admin authentication tokens
echo "Step 1: Setting up authentication tokens..."
export DEV_USER_AUTH_TOKEN="eyJhbGciOiJSUzI1NiIsImtpZCI6IjladmVRTXdVMXZMdVJScUw4UTQzQU8yRjNhWXpncXh0WWhDQmREMkVQTG8iLCJ0eXAiOiJKV1QifQ.eyJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbIioiXSwiYXVkIjpbImFjY291bnQiXSwiYXV0aF90aW1lIjoxNzI2NTA3MzQyLCJhenAiOiJteS1jbGllbnQtaWQiLCJlbWFpbCI6InVzZXIzQGVtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZXhwIjoyNTkwNTA3MzQxLCJncm91cCI6InVzZXJzIiwiaWF0IjoxNzI2NTA3MzQyLCJpc3MiOiJodHRwczovL2tleWNsb2FrLmV4YW1wbGUuY29tL2F1dGgvcmVhbG1zL21hc3RlciIsImp0aSI6ImY4MjIyN2M2LWE3ZjUtNDIxNy1iODE1LWViMGY5MGM4NmM5NSIsIm5hbWUiOiJVc2VyIDMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoiZW1haWwgcHJvZmlsZSIsInN1YiI6ImM1MDhmNDczLTBiOGYtNGRkOS1iYzIyLTExZTEyOGFjMmM4MyIsInR5cCI6IkJlYXJlciIsInVzYWdlUGxhbiI6ImdvbGQifQ.BYewrWWwiPPQzJF5G1mjpJ5LUAcKwP2JO4wQbRZZXBFgiSTf-CRAIBbUuCrIlkdWX0hO791kUDnlfWmEfvmSI-ulCJVfyQ8uEY1CePjSMtWmzHPVOKC-86W5iLzDwFs-iK8DbXsKqwa1aJ_LvksvgzdGoavEyF3Vl7g37moNPekQPaBQbSMoPTuvjapyzsJOz_xdLALLK5uUPbQkdb2yInRKoE85ZUVSo4jUImAEewmom8mRX65v0rPYbWzTeW1vcU6QfZA4MJf5L8mqb5fG2gwhorIPOSL1yryhlu-bkTQRut0Vc4Hscc237IKKVSaVisW3JOqxYYuZL6HeBhEhRA"

export ADMIN_USER_AUTH_TOKEN="eyJhbGciOiJSUzI1NiIsImtpZCI6IjladmVRTXdVMXZMdVJScUw4UTQzQU8yRjNhWXpncXh0WWhDQmREMkVQTG8iLCJ0eXAiOiJKV1QifQ.eyJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbIioiXSwiYXVkIjpbImFjY291bnQiXSwiYXV0aF90aW1lIjoxNzI2NTA3MDIwLCJhenAiOiJteS1jbGllbnQtaWQiLCJlbWFpbCI6ImFkbWluQGVtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZXhwIjoyNTkwNTA3MDE5LCJncm91cCI6ImFkbWluIiwiaWF0IjoxNzI2NTA3MDIwLCJpc3MiOiJodHRwczovL2tleWNsb2FrLmV4YW1wbGUuY29tL2F1dGgvcmVhbG1zL21hc3RlciIsImp0aSI6ImE4NjU3ZGRmLTk0YjItNDJhYy1hY2I2LWUwZjM1YjY5NTU0ZSIsIm5hbWUiOiJBZG1pbiIsInByZWZlcnJlZF91c2VybmFtZSI6ImFkbWluIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6ImVtYWlsIHByb2ZpbGUiLCJzdWIiOiI3OGJkOTBmZS02ZGUwLTQzMTYtYmVmYy0xMWY4ODhlOGIyOGQiLCJ0eXAiOiJCZWFyZXIiLCJ1c2FnZVBsYW4iOiJnb2xkIn0.mqTIyXqVxGj2t7tkg8ReaYj3Zi2C-smSbRkb88kb8A7EqtU3RE_vgSTVIX1lHUkDD4YfVEk7ojfN_mzbMW6VCf1aGOX7t95fjyBsPbhq3jwNkko3qeKDSe9HVUW1mMTA2DXa--sykWoD-lZFMcQVR0KG7iv9AZJHk70zsBkCfSv9_MVEzj2nOm2aHXWfc8dZVih8h9q3LJq3fNR-REQT8wWRDHaH0dpCdXYSnWZCMLwSkKvDqBYnsYOYQucOUDhhd59bX-lgL90R259yk_MLRmJOS_FJsskYOi1ObaOT1SMk_5o6WV3Eef98gozoErsJnmZBOTj-FsRIZ7gWhvLSXg"
echo "Tokens set."
echo

# Prompt the user to input the base URL for the portal server backend, re-prompt if empty
while true; do
    read -p "Enter the API base URL for the portal server backend (e.g., https://solo-dev-portal.glootest.com): " BASE_URL

    # Validate if the input is empty
    if [ -z "$BASE_URL" ]; then
        echo "No base URL provided. Please try again."
    else
        break
    fi
done

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 1 complete. Press enter to proceed to Step 2..."

# Step 2: Create a user
echo
echo "Step 2: Creating a user..."
echo "curl -X PUT $BASE_URL/v1/me -H 'Authorization: Bearer \$DEV_USER_AUTH_TOKEN'"
USER_RESPONSE=$(curl -s -X PUT "$BASE_URL/v1/me" \
  -H "Authorization: Bearer $DEV_USER_AUTH_TOKEN")
echo

# Extract USER_ID from the response
export USER_ID=$(echo $USER_RESPONSE | jq -r '.id')
echo "User created with ID: $USER_ID"
echo

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 2 complete. Press enter to proceed to Step 3..."

# Step 3: Create a team for the user
# Predefined team names and descriptions
PREDEFINED_TEAMS=("Engineering" "Marketing" "Sales" "Custom")

# Prompt for team name
echo "Choose a team name or enter a custom one:"
select TEAM_OPTION in "${PREDEFINED_TEAMS[@]}"; do
    case $TEAM_OPTION in
        "Custom")
            read -p "Enter your custom team name: " TEAM_NAME
            break
            ;;
        *)
            TEAM_NAME=$TEAM_OPTION
            break
            ;;
    esac
done

# Prompt for team description
PREDEFINED_DESCRIPTIONS=("The engineering team" "The marketing team" "The sales team" "Custom")
echo "Choose a team description or enter a custom one:"
select DESCRIPTION_OPTION in "${PREDEFINED_DESCRIPTIONS[@]}"; do
    case $DESCRIPTION_OPTION in
        "Custom")
            read -p "Enter your custom team description: " TEAM_DESCRIPTION
            break
            ;;
        *)
            TEAM_DESCRIPTION=$DESCRIPTION_OPTION
            break
            ;;
    esac
done

# Print the curl command
echo "curl -X POST $BASE_URL/v1/teams -H 'Content-Type: application/json' -H 'Authorization: Bearer \$DEV_USER_AUTH_TOKEN' -d '{\"Name\": \"$TEAM_NAME\", \"Description\": \"$TEAM_DESCRIPTION\"}'"

TEAM_RESPONSE=$(curl -s -X POST "$BASE_URL/v1/teams" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DEV_USER_AUTH_TOKEN" \
  -d "{\"Name\": \"$TEAM_NAME\", \"Description\": \"$TEAM_DESCRIPTION\"}")
echo

# Extract TEAM_ID from the response
export TEAM_ID=$(echo $TEAM_RESPONSE | jq -r '.id')
echo "Team created with ID: $TEAM_ID"
echo

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 3 complete. Press enter to proceed to Step 4..."

# Step 4: Create an application for the team
# Predefined application names
PREDEFINED_APPS=("TestApp1" "DemoApp" "ProdApp" "Custom")

# Prompt for application name
echo "Choose an application name or enter a custom one:"
select APP_OPTION in "${PREDEFINED_APPS[@]}"; do
    case $APP_OPTION in
        "Custom")
            read -p "Enter your custom application name: " APP_NAME
            break
            ;;
        *)
            APP_NAME=$APP_OPTION
            break
            ;;
    esac
done

# Prompt for application description
PREDEFINED_APP_DESCRIPTIONS=("App for testing" "Demo application" "Production app" "Custom")
echo "Choose an application description or enter a custom one:"
select APP_DESCRIPTION_OPTION in "${PREDEFINED_APP_DESCRIPTIONS[@]}"; do
    case $APP_DESCRIPTION_OPTION in
        "Custom")
            read -p "Enter your custom application description: " APP_DESCRIPTION
            break
            ;;
        *)
            APP_DESCRIPTION=$APP_DESCRIPTION_OPTION
            break
            ;;
    esac
done

# Print the curl command
echo "curl -X POST $BASE_URL/v1/teams/$TEAM_ID/apps -H 'Content-Type: application/json' -H 'Authorization: Bearer \$DEV_USER_AUTH_TOKEN' -d '{\"Name\": \"$APP_NAME\", \"Description\": \"$APP_DESCRIPTION\"}'"

APP_RESPONSE=$(curl -s -X POST "$BASE_URL/v1/teams/$TEAM_ID/apps" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DEV_USER_AUTH_TOKEN" \
  -d "{\"Name\": \"$APP_NAME\", \"Description\": \"$APP_DESCRIPTION\"}")
echo

# Extract APPLICATION_ID from the response
export APPLICATION_ID=$(echo $APP_RESPONSE | jq -r '.id')
echo "Application created with ID: $APPLICATION_ID"
echo

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 4 complete. Press enter to proceed to Step 5..."

# Step 5: List available API products and allow user to select one
echo
echo "Step 5: Listing available API products..."
echo "curl -X GET $BASE_URL/v1/api-products -H 'Authorization: Bearer \$DEV_USER_AUTH_TOKEN'"
API_PRODUCTS_RESPONSE=$(curl -s -X GET "$BASE_URL/v1/api-products" \
  -H "Authorization: Bearer $DEV_USER_AUTH_TOKEN")
echo

# Parse and display all available API products
PRODUCT_COUNT=$(echo $API_PRODUCTS_RESPONSE | jq '. | length')
echo "Available API Products:"

for ((i=0; i<$PRODUCT_COUNT; i++))
do
  PRODUCT_NAME=$(echo $API_PRODUCTS_RESPONSE | jq -r ".[$i].name")
  PRODUCT_ID=$(echo $API_PRODUCTS_RESPONSE | jq -r ".[$i].id")
  echo "$((i + 1))) $PRODUCT_NAME (ID: $PRODUCT_ID)"
done

echo

# Keep prompting for valid input until a correct selection is made
while true; do
    read -p "Please select an API product by number (1 to $PRODUCT_COUNT): " PRODUCT_INDEX
    
    # Convert the user's input to zero-based index
    PRODUCT_INDEX=$((PRODUCT_INDEX - 1))

    if [[ -z "$PRODUCT_INDEX" || "$PRODUCT_INDEX" -lt 0 || "$PRODUCT_INDEX" -ge "$PRODUCT_COUNT" ]]; then
        echo "Invalid selection. Please enter a valid number between 1 and $PRODUCT_COUNT."
    else
        break
    fi
done

# Set the selected API_PRODUCT_ID based on user input
export API_PRODUCT_ID=$(echo $API_PRODUCTS_RESPONSE | jq -r ".[$PRODUCT_INDEX].id")

echo "Selected API Product ID: $API_PRODUCT_ID"
echo

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 5 complete. Press enter to proceed to Step 6..."

# Step 6: Create a subscription to the API product for the team's application
echo
echo "Step 6: Creating a subscription to the API product..."
echo "curl -X POST $BASE_URL/v1/apps/\$APPLICATION_ID/subscriptions -H 'Content-Type: application/json' -H 'Authorization: Bearer \$DEV_USER_AUTH_TOKEN' -d '{\"ApiProductId\": \"$API_PRODUCT_ID\"}'"
SUBSCRIPTION_RESPONSE=$(curl -s -w "\nHTTP_STATUS_CODE:%{http_code}" -X POST "$BASE_URL/v1/apps/$APPLICATION_ID/subscriptions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DEV_USER_AUTH_TOKEN" \
  -d "{\"ApiProductId\": \"$API_PRODUCT_ID\"}")
echo

# Split the response and the HTTP status code
HTTP_BODY=$(echo "$SUBSCRIPTION_RESPONSE" | sed -e 's/HTTP_STATUS_CODE:.*//g')
HTTP_STATUS=$(echo "$SUBSCRIPTION_RESPONSE" | tr -d '\n' | sed -e 's/.*HTTP_STATUS_CODE://')

echo "Full subscription response: $HTTP_BODY"
echo "HTTP Status: $HTTP_STATUS"
echo

# Extract the Subscription ID
if [[ -z "$HTTP_BODY" && "$HTTP_STATUS" == "201" ]]; then
  echo "Subscription created successfully, but no response body. Skipping subscription ID extraction."
else
  export SUBSCRIPTION_ID=$(echo "$HTTP_BODY" | jq -r '.id')
fi

# Discover Subscription ID if it wasn't returned
if [[ -z "$SUBSCRIPTION_ID" || "$SUBSCRIPTION_ID" == "null" ]]; then
  echo "Discovering subscription ID by listing subscriptions..."
  echo "curl -X GET $BASE_URL/v1/apps/\$APPLICATION_ID/subscriptions -H 'Authorization: Bearer \$DEV_USER_AUTH_TOKEN'"
  EXISTING_SUBSCRIPTIONS=$(curl -s -X GET "$BASE_URL/v1/apps/$APPLICATION_ID/subscriptions" \
    -H "Authorization: Bearer $DEV_USER_AUTH_TOKEN")
  export SUBSCRIPTION_ID=$(echo "$EXISTING_SUBSCRIPTIONS" | jq -r '.[0].id')
  echo
fi

echo "Subscription ID: $SUBSCRIPTION_ID"
echo

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 6 complete. Press enter to proceed to Step 7..."

# Step 7: Approve the subscription as an admin
echo
echo "Step 7: Approving subscription..."
echo "curl -X POST $BASE_URL/v1/subscriptions/\$SUBSCRIPTION_ID/approve -H 'Authorization: Bearer \$ADMIN_USER_AUTH_TOKEN'"
curl -s -X POST "$BASE_URL/v1/subscriptions/$SUBSCRIPTION_ID/approve" \
  -H "Authorization: Bearer $ADMIN_USER_AUTH_TOKEN"
echo
echo "Subscription approved."
echo

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 7 complete. Press enter to proceed to Step 8..."

# Step 8: Set a dynamic rate limit for the subscription
echo
echo "Step 8: Setting a dynamic rate limit for the subscription..."

# Keep prompting for input until a valid number is provided
while true; do
    read -p "Enter the number of requests per minute: " REQUESTS_PER_UNIT
    
    # Validate input is not empty and is a number
    if [[ -z "$REQUESTS_PER_UNIT" || ! "$REQUESTS_PER_UNIT" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Please enter a valid number."
    else
        break
    fi
done

# Always set the unit to MINUTE for the demo
UNIT="MINUTE"

echo "Applying rate limit of $REQUESTS_PER_UNIT requests per $UNIT to subscription $SUBSCRIPTION_ID..."
echo

# Print the curl command
echo "curl -X POST $BASE_URL/v1/subscriptions/$SUBSCRIPTION_ID/metadata -H 'Content-Type: application/json' -H 'Authorization: Bearer \$ADMIN_USER_AUTH_TOKEN' -d '{\"rateLimit\": {\"requestsPerUnit\": \"$REQUESTS_PER_UNIT\", \"unit\": \"$UNIT\"}, \"customMetadata\": {\"key2\": \"value2\"}}'"

curl -X POST "$BASE_URL/v1/subscriptions/$SUBSCRIPTION_ID/metadata" \
    -H "Content-Type: application/json" \
    -d "{\"rateLimit\": {\"requestsPerUnit\": \"$REQUESTS_PER_UNIT\", \"unit\": \"$UNIT\"}, \"customMetadata\": {\"key2\": \"value2\"}}" \
    -H "Authorization: Bearer $ADMIN_USER_AUTH_TOKEN"
echo
echo "Rate limit applied. Note that the time unit is configurable, but for this demo, it's set to MINUTE."

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 8 complete. Press enter to proceed to Step 9..."

# Step 9: API Key Creation
# Predefined API key names
PREDEFINED_KEYS=("TestKey" "ProdKey" "DevKey" "Custom")

# Prompt for API key name
echo "Choose an API key name or enter a custom one:"
select KEY_OPTION in "${PREDEFINED_KEYS[@]}"; do
    case $KEY_OPTION in
        "Custom")
            read -p "Enter your custom API key name: " API_KEY_NAME
            break
            ;;
        *)
            API_KEY_NAME=$KEY_OPTION
            break
            ;;
    esac
done

# Print the curl command
echo "curl -X POST $BASE_URL/v1/apps/$APPLICATION_ID/api-keys -H 'Content-Type: application/json' -H 'Authorization: Bearer \$DEV_USER_AUTH_TOKEN' -d '{\"apiKeyName\": \"$API_KEY_NAME\"}'"

API_KEY_RESPONSE=$(curl -s -X POST "$BASE_URL/v1/apps/$APPLICATION_ID/api-keys" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DEV_USER_AUTH_TOKEN" \
  -d "{\"apiKeyName\": \"$API_KEY_NAME\"}")
echo

# Extract API_KEY and API_KEY_ID
export API_KEY=$(echo $API_KEY_RESPONSE | jq -r '.apiKey')
export API_KEY_ID=$(echo $API_KEY_RESPONSE | jq -r '.id')

echo "API Key created: $API_KEY"
echo "API Key ID: $API_KEY_ID"
echo

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 9 complete. Press enter to proceed to Step 10..."

# Step 10: Validate the API key with the metadata endpoint
echo
echo "Step 10: Validating the API key..."

# Predefined API product options
PREDEFINED_API_PRODUCTS=("tracks" "petstore" "gloo-portal-server" "openlibrary" "Custom")

# Display options to the user
select API_PRODUCT_OPTION in "${PREDEFINED_API_PRODUCTS[@]}"; do
    case $API_PRODUCT_OPTION in
        "Custom")
            read -p "Enter your custom API Product ID: " CUSTOM_API_PRODUCT_ID
            API_PRODUCT_ID=$CUSTOM_API_PRODUCT_ID
            break
            ;;
        *)
            API_PRODUCT_ID=$API_PRODUCT_OPTION
            break
            ;;
    esac
done

echo "Selected API Product ID: $API_PRODUCT_ID"
echo

# Make the API call using the selected or custom API Product ID
echo "curl -X GET $BASE_URL/v1/metadata?apiKey=\$API_KEY&apiProductId=\$API_PRODUCT_ID"
curl -s -X GET "$BASE_URL/v1/metadata?apiKey=$API_KEY&apiProductId=$API_PRODUCT_ID"
echo

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 10 complete. Press enter to proceed to Step 11..."

# Step 11: Set the API product's URI
echo
echo "Step 11: Choose an API product's URI or enter a custom one:"

# Predefined URIs
PREDEFINED_URIS=(
  "https://tracks.glootest.com/tracks/c_0"
  "https://petstore.glootest.com/pets/pet"
  "https://solo-dev-portal.glootest.com/v1/api-products"
  "https://openlibrary.glootest.com/api/books?bibkeys=ISBN%3A0201558025&format=json&jscmd=viewapi"
  "Custom"
)

# Display options to the user
select URI_OPTION in "${PREDEFINED_URIS[@]}"; do
    case $URI_OPTION in
        "Custom")
            read -p "Enter your custom API URI: " CUSTOM_URI
            API_PRODUCT_URI=$CUSTOM_URI
            break
            ;;
        *)
            API_PRODUCT_URI=$URI_OPTION
            break
            ;;
    esac
done

echo "Selected API Product URI: $API_PRODUCT_URI"
echo

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 11 complete. Press enter to proceed to Step 12..."

# Step 12: Call the selected API product's endpoint without the API key
echo
echo "Calling the API product's endpoint without the API key (expecting 403)..."

# Print the curl command for calling the API without the API key
echo "curl $API_PRODUCT_URI"

curl "$API_PRODUCT_URI"
echo
echo "Expecting a Rejected - 403 error."
echo

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 12 complete. Press enter to proceed to Step 13..."

# Step 13: Call the tracks endpoint with the API key
echo
echo "Step 13: Calling the API product's endpoint with the API key (expecting 200 responses until rate limit is hit)..."
echo "curl $API_PRODUCT_URI -H 'api-key: \$API_KEY'"

# Loop for (requests per unit + 1) times
for ((i=1; i<=REQUESTS_PER_UNIT+1; i++)); do
  echo "Attempt $i:"
  
  # Perform the curl request and extract only the HTTP status code
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$API_PRODUCT_URI" \
    -H "api-key: $API_KEY")
  
  echo "HTTP Status Code: $HTTP_STATUS"
  echo "-------------------------"
done

echo "Expecting dynamic rate limiting after attempt $((REQUESTS_PER_UNIT+1))."
echo

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 13 complete. Press enter to proceed to Step 14..."

# Step 14: Revoke the API key
echo
echo "Step 14: Revoking the API key..."
echo
echo "curl -X DELETE $BASE_URL/v1/api-keys/\$API_KEY_ID -H 'Authorization: Bearer \$DEV_USER_AUTH_TOKEN' -H 'User-Agent: curl/8.9.0' -H 'Accept: */*'"

# Perform the API key revocation and capture the response along with the HTTP status code
REVOKE_RESPONSE=$(curl -s -w "\nHTTP_STATUS_CODE:%{http_code}" -X DELETE "$BASE_URL/v1/api-keys/$API_KEY_ID" \
  -H "Authorization: Bearer $DEV_USER_AUTH_TOKEN" \
  -H "User-Agent: curl/8.9.0" \
  -H "Accept: */*")

# Extract the HTTP status code from the response
REVOKE_STATUS=$(echo "$REVOKE_RESPONSE" | tr -d '\n' | sed -e 's/.*HTTP_STATUS_CODE://')
echo

# Check if the HTTP status code is 204 (No Content)
if [[ "$REVOKE_STATUS" == "204" ]]; then
  echo "API Key revoked successfully. HTTP Status: $REVOKE_STATUS"
else
  echo "Failed to revoke the API key. HTTP Status: $REVOKE_STATUS"
  echo "Response: $REVOKE_RESPONSE"
fi
echo

# Space between steps
echo "-------------------------"

# Pause for demonstration
read -p "Step 14 complete. Press enter to proceed to Step 15..."

# Step 15: Call the tracks endpoint with the revoked API key (expecting 403)
echo
echo "Step 15: Calling the API product's endpoint with the revoked API key (expecting 403)..."
echo "curl $API_PRODUCT_URI -H 'api-key: \$API_KEY'"
curl "$API_PRODUCT_URI" \
  -H "api-key: $API_KEY"
echo
echo
echo "Expecting a Rejected - 403 error."
echo

# Space between steps
echo "-------------------------"

echo "All operations completed successfully!"
