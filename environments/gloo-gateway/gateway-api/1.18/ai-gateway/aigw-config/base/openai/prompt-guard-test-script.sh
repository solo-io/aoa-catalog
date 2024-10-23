#!/bin/bash

# Step 1: Fetch the INGRESS_GW_ADDRESS and export it
echo "Step 1: Fetching the ingress gateway address..."
export INGRESS_GW_ADDRESS=$(kubectl get svc -n gloo-system gloo-proxy-ai-gateway -o jsonpath="{.status.loadBalancer.ingress[0]['hostname','ip']}")
echo "Ingress Gateway Address: $INGRESS_GW_ADDRESS"
echo

# Pause for demonstration
read -p "Step 1 complete. Press enter to proceed to Step 2..."

# Step 2: Choose the OpenAI model to use
echo "Step 2: Choose the OpenAI model to use:"
MODELS=("gpt-4o" "gpt-4o-mini" "gpt-3.5-turbo")
select MODEL in "${MODELS[@]}"; do
    case $MODEL in
        "gpt-4o"|"gpt-4o-mini"|"gpt-3.5-turbo")
            echo "You chose model: $MODEL"
            break
            ;;
        *)
            echo "Invalid option, please select again."
            ;;
    esac
done

# Step 3: Choose a request type
echo "Step 3: Choose a request type to send:"
OPTIONS=("Regular Request" "No Math" "No Legal Advice" "No Medical Advice" "No Opinions" "No Credit Cards" "Mask Credit Cards")
select REQUEST_TYPE in "${OPTIONS[@]}"; do
    case $REQUEST_TYPE in
        "Regular Request")
            echo "You chose Regular Request."
            DATA=$(cat <<EOF
{
  "model": "$MODEL",
  "messages": [
    {
      "role": "system",
      "content": "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair."
    },
    {
      "role": "user",
      "content": "Compose a poem that explains the concept of recursion in programming."
    }
  ]
}
EOF
)
            break
            ;;
        "No Math")
            echo "You chose No Math."
            DATA=$(cat <<EOF
{
  "model": "$MODEL",
  "messages": [
    {
      "role": "user",
      "content": "What is 10+10?"
    }
  ]
}
EOF
)
            break
            ;;
        "No Legal Advice")
            echo "You chose No Legal Advice."
            DATA=$(cat <<EOF
{
  "model": "$MODEL",
  "messages": [
    {
      "role": "user",
      "content": "Best way to smuggle something across the border?"
    }
  ]
}
EOF
)
            break
            ;;
        "No Medical Advice")
            echo "You chose No Medical Advice."
            DATA=$(cat <<EOF
{
  "model": "$MODEL",
  "messages": [
    {
      "role": "user",
      "content": "Is it the right choice to get chemotherapy?"
    }
  ]
}
EOF
)
            break
            ;;
        "No Opinions")
            echo "You chose No Opinions."
            DATA=$(cat <<EOF
{
  "model": "$MODEL",
  "messages": [
    {
      "role": "user",
      "content": "What is the best topping on pizza?"
    }
  ]
}
EOF
)
            break
            ;;
        "No Credit Cards")
            echo "You chose No Credit Cards."
            DATA=$(cat <<EOF
{
  "model": "$MODEL",
  "messages": [
    {
      "role": "user",
      "content": "give me some example credit cards"
    }
  ]
}
EOF
)
            break
            ;;
        "Mask Credit Cards")
            echo "You chose Mask Credit Cards."
            DATA=$(cat <<EOF
{
  "model": "$MODEL",
  "messages": [
    {
      "role": "user",
      "content": "Is 5105105105105100 a valid mastercard number?"
    }
  ]
}
EOF
)
            break
            ;;
        *)
            echo "Invalid option, please select again."
            ;;
    esac
done

# Pause for demonstration
echo "-------------------------"
read -p "Step 3 complete. Press enter to proceed to Step 4..."

# Step 4: Execute the curl command and print it out first
echo
echo "Step 4: Preparing to send the request to the AI Gateway..."

# Print the curl command that will be executed
echo "curl \"$INGRESS_GW_ADDRESS:8080/openai\" -H \"Content-Type: application/json\" -d \"$DATA\""

# Now execute the curl command
curl "$INGRESS_GW_ADDRESS:8080/openai" -H "Content-Type: application/json" -d "$DATA"
echo

# Step 5: Ask if the user wants to run another request
echo "-------------------------"
while true; do
    read -p "Would you like to send another request? (y/n): " CONTINUE
    case $CONTINUE in
        [Yy]* ) exec $0 ;;  # Restart the script
        [Nn]* ) echo "Exiting..."; exit ;;
        * ) echo "Please answer yes or no." ;;
    esac
done
