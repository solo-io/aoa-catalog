#!/bin/bash

export ALICE_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyAiaXNzIjogInNvbG8uaW8iLCAib3JnIjogInNvbG8uaW8iLCAic3ViIjogImFsaWNlIiwgInRlYW0iOiAiZGV2IiwgImxsbXMiOiB7ICJvcGVuYWkiOiBbICJncHQtMy41LXR1cmJvIiBdIH0gfQ.I7whTti0aDKxlILc5uLK9oo6TljGS6JUrjPVd6z1PxzucUa_cnuKkY0qj_wrkzyVN5djy4t2ggE1uBO8Llpwi-Ygru9hM84-1m53aO07JYFya1VTDsI25tCRG8rYhShDdAP5L935SIARta2QtHhrVcd1Ae7yfTDZ8G1DXLtjR2QelszCd2R8PioCQmqJ8PeKg4sURhu05GlBCZoXES9-rtPVbe6j3YLBTodJAvLHhyy3LgV_QbN7IiZ5qEywdKHoEF4D4aCUf_LqPp4NoqHXnGT4jLzWJEtZXHQ4sgRy_5T93NOLzWLdIjgMjGO_F0aVLwBzU-phykOVfcBPaMvetg"
export BOB_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyAiaXNzIjogInNvbG8uaW8iLCAib3JnIjogInNvbG8uaW8iLCAic3ViIjogImJvYiIsICJ0ZWFtIjogIm9wcyIsICJsbG1zIjogeyAibWlzdHJhbGFpIjogWyAibWlzdHJhbC1sYXJnZS1sYXRlc3QiIF0gfSB9.p7J2UFwnUJ6C7eXsFCSKb5b7ecWZ75JO4TUJHafjLv8jJ7GzKfJVk7ney19PYUrWrO4ntwnnK5_sY7yaLUBCJ3fv9pcoKyRtJTw1VMMTQsKkWFgvy-jEwc9M-D5lrUfR1HXGEUm6NBaj_Ja78XScPZb_-APPqMIvzDZU04vd6hna3UMc4DZE0wcnTjOqoND0GllHLupYTfgX0v9_AYJiKRAcJvol1W14dI7szpY5GFZtPqq0kl1g0sJPg-HQKwf7Cfvr_JLjkepNJ6A1lsrG8QbuUvMUAdaHzwLvF3L_G6VRjEte6okZpaq0g2urWpZgdNmPVN71Q_0WhyrJTr6SyQ"

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

echo "Starting the Gloo AI Gateway Rate Limiting Demo..."
echo

# Step 1: Configure a simple route to qwen-0.5b LLM backend
read -p "Step 1: Configure a simple route to qwen-0.5b LLM backend. Press enter to proceed..."
kubectl apply -f route
echo
cat route/*.yaml
echo "Route applied successfully."
echo

# Step 2: Get AI Gateway Load Balancer Address
read -p "Step 2: Retrieve the AI Gateway Load Balancer address. Press enter to proceed..."
export GATEWAY_IP=$(kubectl get svc -n gloo-system gloo-proxy-ai-gateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}{.status.loadBalancer.ingress[0].hostname}')
echo "Gateway IP: $GATEWAY_IP"
echo

# Step 3: Test the AI Gateway Endpoint
read -p "Step 3: Test the AI Gateway endpoint. Press enter to proceed..."
curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/qwen -H "Content-Type: application/json" -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a cloud native solutions architect, skilled in explaining complex technical concepts such as API Gateway, microservices, LLM operations, kubernetes, and advanced networking patterns"
      },
      {
        "role": "user",
        "content": "Write me a 20-word pitch on why I should use an AI gateway in my Kubernetes cluster"
      }
    ]
  }'
echo
echo "^^^^"
echo "The response should indicate that qwen-0.5b is serving the request."
echo

# Step 4: Set up Access Control
read -p "Step 4: Configure access control to restrict unauthenticated access. Press enter to proceed..."
kubectl apply -f access-control
echo
cat access-control/*.yaml
echo
echo "Access control configured successfully."
echo

# Step 5: Test Access Control Without JWT
read -p "Step 5: Test the endpoint without JWT to verify access control. Press enter to proceed..."
curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/qwen -H "Content-Type: application/json" -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a cloud native solutions architect, skilled in explaining complex technical concepts such as API Gateway, microservices, LLM operations, kubernetes, and advanced networking patterns"
      },
      {
        "role": "user",
        "content": "Write me a 20-word pitch on why I should use an AI gateway in my Kubernetes cluster"
      }
    ]
  }'
echo
echo "^^^^"
echo "The request should return a 401 HTTP response code, indicating that JWT is missing."
echo

# Step 6: Save and Test Alice's JWT Token
read -p "Step 6: Save and test Alice's JWT token. Press enter to proceed..."
curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/qwen -H "Authorization: Bearer $ALICE_TOKEN" -H "Content-Type: application/json" -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a cloud native solutions architect, skilled in explaining complex technical concepts such as API Gateway, microservices, LLM operations, kubernetes, and advanced networking patterns"
      },
      {
        "role": "user",
        "content": "Write me a 20-word pitch on why I should use an AI gateway in my Kubernetes cluster"
      }
    ]
  }'
echo
echo "^^^^"
echo "Alice's request should succeed."
echo

# Step 7: Test Bob's JWT Token
read -p "Step 7: Save and test Bob's JWT token. Press enter to proceed..."
curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/qwen -H "Authorization: Bearer $BOB_TOKEN" -H "Content-Type: application/json" -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a cloud native solutions architect, skilled in explaining complex technical concepts such as API Gateway, microservices, LLM operations, kubernetes, and advanced networking patterns"
      },
      {
        "role": "user",
        "content": "Write me a 20-word pitch on why I should use an AI gateway in my Kubernetes cluster"
      }
    ]
  }'
echo
echo "^^^^"
echo "Bob's request should also succeed."
echo

# Step 8: Configure RBAC
read -p "Step 8: Configure RBAC to enforce team-based access. Press enter to proceed..."
kubectl apply -f access-control/rbac
echo
cat access-control/rbac/*.yaml
echo
echo "RBAC policies applied."
echo

# Step 9: Test RBAC Policies
read -p "Step 9: Test RBAC policies. Press enter to proceed..."
echo
echo "Testing Alice's access..."
curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/qwen -H "Authorization: Bearer $ALICE_TOKEN" -H "Content-Type: application/json" -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a cloud native solutions architect, skilled in explaining complex technical concepts such as API Gateway, microservices, LLM operations, kubernetes, and advanced networking patterns"
      },
      {
        "role": "user",
        "content": "Write me a 20-word pitch on why I should use an AI gateway in my Kubernetes cluster"
      }
    ]
  }'
echo
echo "^^^^"
echo "Alice's request should succeed because she belongs to the dev team."
echo
echo
echo "Testing Bob's access..."
curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/qwen -H "Authorization: Bearer $BOB_TOKEN" -H "Content-Type: application/json" -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a cloud native solutions architect, skilled in explaining complex technical concepts such as API Gateway, microservices, LLM operations, kubernetes, and advanced networking patterns"
      },
      {
        "role": "user",
        "content": "Write me a 20-word pitch on why I should use an AI gateway in my Kubernetes cluster"
      }
    ]
  }'
echo
echo "^^^^"
echo "Bob's request should fail with 'RBAC: access denied' because he is not a part of the dev team"
echo

# Step 10: Configure Tiered Rate Limiting
read -p "Step 10: Configure tiered rate limiting. Press enter to proceed..."
echo "Cleaning up previous RBAC policies if configured"
kubectl delete -f access-control/rbac
kubectl apply -f tiered-rate-limit
echo
cat tiered-rate-limit/*.yaml
echo
echo "Tiered rate limiting policies applied."
echo

# Step 11: Test Rate Limiting
echo "Step 11: Test the rate-limiting policies."
echo "Press Enter to send a request as Alice (1), Bob (2), or type 'next' to finish this step."

while true; do
  # Prompt user to choose a token by number
  read -p "Select a user (1 for Alice, 2 for Bob, or 'next' to finish this step): " user_input
  if [[ "$user_input" == "next" ]]; then
    echo "Exiting rate-limiting test."
    echo
    break
  elif [[ "$user_input" == "1" ]]; then
    TOKEN=$ALICE_TOKEN
    USER="Alice"
  elif [[ "$user_input" == "2" ]]; then
    TOKEN=$BOB_TOKEN
    USER="Bob"
  else
    echo "Invalid input. Please enter 1, 2, or 'next'."
    continue
  fi

  echo "Sending request as $USER..."
  curl -ik $PROTOCOL://$GATEWAY_IP:$AIGW_PORT/qwen \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "messages": [
        {
          "role": "system",
          "content": "You are a cloud native solutions architect, skilled in explaining complex technical concepts such as API Gateway, microservices, LLM operations, kubernetes, and advanced networking patterns"
        },
        {
          "role": "user",
          "content": "Write me a 20-word pitch on why I should use an AI gateway in my Kubernetes cluster"
        }
      ]
    }'
  echo
done

# Step 12: View AI Gateway Metrics
echo "Step 12: View AI Gateway Metrics."
echo "Setting up port-forwarding to access AI Gateway metrics..."
echo

# Start port-forwarding in the background
kubectl port-forward -n gloo-system $(kubectl get pod -l gateway.networking.k8s.io/gateway-name=ai-gateway -n gloo-system -o jsonpath='{.items[0].metadata.name}') 9092:9092 >/dev/null 2>&1 &

# Capture the background process ID to terminate later
PORT_FORWARD_PID=$!

# Wait a few seconds to ensure port-forwarding is established
sleep 2

# Curl the metrics endpoint
echo "Fetching AI Gateway metrics for ai_prompt_tokens_total"
curl -s http://localhost:9092 | grep "ai_prompt_tokens_total"
echo
echo "To view all of the available AI gateway metrics navigate to http://localhost:9092 in your browser"
echo

# Step 13: Cleanup
read -p "Step 13: Cleanup demo resources. Press enter to proceed..."
kubectl delete -f tiered-rate-limit
kubectl delete -f access-control/rbac
kubectl delete -f access-control
kubectl delete -f route
kubectl delete pods -l gloo=redis -n gloo-system

# Kill the port-forwarding process
if ps -p $PORT_FORWARD_PID > /dev/null; then
  kill $PORT_FORWARD_PID >/dev/null 2>&1
fi

echo "Cleanup completed."
echo

echo "END"
