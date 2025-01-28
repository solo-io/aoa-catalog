#!/bin/bash

# Prompt the user for protocol with predefined options
echo "Select the protocol:"
echo "1) http"
echo "2) https"
read -p "Enter your choice: " PROTOCOL_CHOICE

case $PROTOCOL_CHOICE in
  1|"")
    PROTOCOL="http"
    ;;
  2)
    PROTOCOL="https"
    ;;
  *)
    echo "Invalid choice. Defaulting to http."
    PROTOCOL="http"
    ;;
esac

# Prompt the user for port with predefined options
echo
echo "Select the port:"
if [ "$PROTOCOL" == "http" ]; then
  echo "1) 8080 (default)"
elif [ "$PROTOCOL" == "https" ]; then
  echo "1) 443 (default)"
fi
echo "2) Custom"

read -p "Enter your choice: " PORT_CHOICE

case $PORT_CHOICE in
  1|"")
    if [ "$PROTOCOL" == "http" ]; then
      AIGW_PORT="8080"
    elif [ "$PROTOCOL" == "https" ]; then
      AIGW_PORT="443"
    fi
    ;;
  2)
    read -p "Enter your custom port: " CUSTOM_PORT
    AIGW_PORT=$CUSTOM_PORT
    ;;
  *)
    echo "Invalid choice. Defaulting to the protocol's default port."
    if [ "$PROTOCOL" == "http" ]; then
      AIGW_PORT="8080"
    elif [ "$PROTOCOL" == "https" ]; then
      AIGW_PORT="443"
    fi
    ;;
esac

echo
echo "Using protocol: $PROTOCOL"
echo "Using port: $AIGW_PORT"
echo

echo "Starting the Gloo AI Gateway Prompt Management Demo..."
echo

# Step 1: Configure a simple route to deepseek LLM backend
read -p "Step 1: Configure a simple route to deepseek LLM backend. Press enter to proceed..."

echo
cat route/ollama-deepseek-1.5-upstream.yaml
echo

# Step 3: Review HTTPRoute for deepseek
echo
read -p "Step 2: Review HTTPRoute for deepseek. Press enter to proceed..."
echo
cat route/deepseek-httproute.yaml
echo

# Step 3: Configure deepseek route
read -p "Step 3: Apply traffic shift configuration. Press enter to proceed..."
kubectl apply -f route
echo

# Step 2: Get AI Gateway Load Balancer Address
read -p "Step 2: Retrieve the AI Gateway Load Balancer address. Press enter to proceed..."
export GATEWAY_IP=$(kubectl get svc -n gloo-system --selector=gateway.networking.k8s.io/gateway-name=ai-gateway -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}{.items[*].status.loadBalancer.ingress[0].hostname}')
echo "Gateway IP: $GATEWAY_IP"

# Step 3: Test deepseek endpoint
echo
echo "Testing deepseek endpoint with a simple math question "what is 10+10?""

while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  if [[ "$user_input" == "next" ]]; then
    echo "Step 3 complete."
    echo
    break
  fi

  echo "Sending request to deepseek endpoint..."
  curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/deepseek -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "user",
          "content": "What is 10+10?"
        }
      ]
    }'
  echo
  echo "^^^^"
  echo "deepseek should respond with the answer of 10+10 in the response above"
  echo
done

# Step 4: Configure organization-level prompts
read -p "Step 4: Prepend or Append organization-level prompts using a RouteOption. Press enter to proceed..."
kubectl apply -f prompt-management/no-math
echo
cat prompt-management/no-math/*.yaml
echo
echo "RouteOption applied successfully."

# Step 5: Test deepseek endpoint
echo
echo "Testing deepseek endpoint with a simple math question "what is 10+10?" with prompt injections applied"

while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  if [[ "$user_input" == "next" ]]; then
    echo "Step 5 complete."
    echo
    break
  fi

  echo "Sending request to deepseek endpoint..."
  curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/deepseek -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "user",
          "content": "What is 10+10?"
        }
      ]
    }'
  echo
  echo "^^^^"
  echo "deepseek should respond that it cannot answer math problems above"
  echo
done

# Step 6: Configure organization-level prompts
read -p "Step 6: Prepend or Append organization-level prompts using a RouteOption. Press enter to proceed..."
kubectl apply -f prompt-management/complete-override
echo
cat prompt-management/complete-override/*.yaml
echo
echo "RouteOption applied successfully."
echo

# Step 7: Test deepseek endpoint
echo
echo "Testing deepseek endpoint with a simple math question "what is 10+10?" with prompt injections applied"

while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  if [[ "$user_input" == "next" ]]; then
    echo "Step 7 complete."
    echo
    break
  fi

  echo "Sending request to deepseek endpoint..."
  curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/deepseek -H "Content-Type: application/json" -d '{
      "messages": [
        {
          "role": "user",
          "content": "What is 10+10?"
        }
      ]
    }'
  echo
  echo "^^^^"
  echo "deepseek should respond with "i love lamp""
  echo
done


# Step 8: Cleanup
read -p "Step 8: Cleanup demo resources. Press enter to proceed..."
kubectl delete -f prompt-management/no-math
kubectl delete -f prompt-management/complete-override
kubectl delete -f route
echo "Cleanup completed."
echo

echo "END"