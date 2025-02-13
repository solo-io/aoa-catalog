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

echo "Starting the Gloo AI Gateway Semantic Cache Demo..."
echo

# clear cache
kubectl delete pods -n gloo-system -l app=redis-cache >/dev/null 2>&1

# Step 1: Configure a simple route to openai LLM backend
read -p "Step 1: Configure a simple route to openai LLM backend. Press enter to proceed..."
kubectl create secret generic openai-secret -n gloo-system \
--from-literal="Authorization=Bearer $OPENAI_API_KEY" \
--dry-run=client -oyaml | kubectl apply -f -
kubectl apply -f route
echo
cat route/*.yaml
echo
echo "Route applied successfully."
echo

# Step 2: Get AI Gateway Load Balancer Address
read -p "Step 2: Retrieve the AI Gateway Load Balancer address. Press enter to proceed..."
export GATEWAY_IP=$(kubectl get svc -n gloo-system --selector=gateway.networking.k8s.io/gateway-name=ai-gateway -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}{.items[*].status.loadBalancer.ingress[0].hostname}')
echo "Gateway IP: $GATEWAY_IP"
echo

# Step 3: Test OpenAI endpoint with the "Hi" use case
echo "Testing OpenAI endpoint with the "Hi" use case."

while true; do
  read -p "Press Enter to send a request, or type 'next' to move on: " user_input
  if [[ "$user_input" == "next" ]]; then
    echo "Exiting test."
    break
  fi

  echo "Sending request to OpenAI endpoint..."
  curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/openai -H "Content-Type: application/json" -d '{
      "model": "gpt-4o-mini",
      "messages": [
        {
          "role": "user",
          "content": "Hi"
        }
      ]
    }'
  echo
  echo
  echo "Responses should come from gpt-4o-mini model first, and then from the cache on subsequent requests"
  echo "This can be validated by the presence of the 'x-gloo-semantic-cache: hit' header"
  echo
done

# Step 4: Cleanup
echo
read -p "Step 4: Cleanup demo resources. Press enter to proceed..."
kubectl delete -f route
echo
echo "Cleanup completed."
echo