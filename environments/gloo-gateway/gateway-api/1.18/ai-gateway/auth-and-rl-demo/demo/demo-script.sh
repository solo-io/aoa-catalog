#!/bin/bash

export ALICE_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyAiaXNzIjogInNvbG8uaW8iLCAib3JnIjogInNvbG8uaW8iLCAic3ViIjogImFsaWNlIiwgInRlYW0iOiAiZGV2IiwgImxsbXMiOiB7ICJvcGVuYWkiOiBbICJncHQtMy41LXR1cmJvIiBdIH0gfQ.I7whTti0aDKxlILc5uLK9oo6TljGS6JUrjPVd6z1PxzucUa_cnuKkY0qj_wrkzyVN5djy4t2ggE1uBO8Llpwi-Ygru9hM84-1m53aO07JYFya1VTDsI25tCRG8rYhShDdAP5L935SIARta2QtHhrVcd1Ae7yfTDZ8G1DXLtjR2QelszCd2R8PioCQmqJ8PeKg4sURhu05GlBCZoXES9-rtPVbe6j3YLBTodJAvLHhyy3LgV_QbN7IiZ5qEywdKHoEF4D4aCUf_LqPp4NoqHXnGT4jLzWJEtZXHQ4sgRy_5T93NOLzWLdIjgMjGO_F0aVLwBzU-phykOVfcBPaMvetg"
export BOB_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyAiaXNzIjogInNvbG8uaW8iLCAib3JnIjogInNvbG8uaW8iLCAic3ViIjogImJvYiIsICJ0ZWFtIjogIm9wcyIsICJsbG1zIjogeyAibWlzdHJhbGFpIjogWyAibWlzdHJhbC1sYXJnZS1sYXRlc3QiIF0gfSB9.p7J2UFwnUJ6C7eXsFCSKb5b7ecWZ75JO4TUJHafjLv8jJ7GzKfJVk7ney19PYUrWrO4ntwnnK5_sY7yaLUBCJ3fv9pcoKyRtJTw1VMMTQsKkWFgvy-jEwc9M-D5lrUfR1HXGEUm6NBaj_Ja78XScPZb_-APPqMIvzDZU04vd6hna3UMc4DZE0wcnTjOqoND0GllHLupYTfgX0v9_AYJiKRAcJvol1W14dI7szpY5GFZtPqq0kl1g0sJPg-HQKwf7Cfvr_JLjkepNJ6A1lsrG8QbuUvMUAdaHzwLvF3L_G6VRjEte6okZpaq0g2urWpZgdNmPVN71Q_0WhyrJTr6SyQ"

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
curl -i http://$GATEWAY_IP:8080/qwen -H "Content-Type: application/json" -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a solutions architect for Kubernetes networking, skilled in explaining complex technical concepts surrounding API Gateway, Service Mesh, and CNI"
      },
      {
        "role": "user",
        "content": "Write me a 20-word pitch on why I should use a service mesh in my Kubernetes cluster"
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
curl -i http://$GATEWAY_IP:8080/qwen -H "Content-Type: application/json" -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a solutions architect for Kubernetes networking, skilled in explaining complex technical concepts surrounding API Gateway, Service Mesh, and CNI"
      },
      {
        "role": "user",
        "content": "Write me a 20-word pitch on why I should use a service mesh in my Kubernetes cluster"
      }
    ]
  }'
echo
echo "^^^^"
echo "The request should return a 401 HTTP response code, indicating that JWT is missing."
echo

# Step 6: Save and Test Alice's JWT Token
read -p "Step 6: Save and test Alice's JWT token. Press enter to proceed..."
curl -i http://$GATEWAY_IP:8080/qwen -H "Authorization: Bearer $ALICE_TOKEN" -H "Content-Type: application/json" -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a solutions architect for Kubernetes networking, skilled in explaining complex technical concepts surrounding API Gateway, Service Mesh, and CNI"
      },
      {
        "role": "user",
        "content": "Write me a 20-word pitch on why I should use a service mesh in my Kubernetes cluster"
      }
    ]
  }'
echo
echo "^^^^"
echo "Alice's request should succeed."
echo

# Step 7: Test Bob's JWT Token
read -p "Step 7: Save and test Bob's JWT token. Press enter to proceed..."
curl -i http://$GATEWAY_IP:8080/qwen -H "Authorization: Bearer $BOB_TOKEN" -H "Content-Type: application/json" -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a solutions architect for Kubernetes networking, skilled in explaining complex technical concepts surrounding API Gateway, Service Mesh, and CNI"
      },
      {
        "role": "user",
        "content": "Write me a 20-word pitch on why I should use a service mesh in my Kubernetes cluster"
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
curl -i http://$GATEWAY_IP:8080/qwen -H "Authorization: Bearer $ALICE_TOKEN" -H "Content-Type: application/json" -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a solutions architect for Kubernetes networking, skilled in explaining complex technical concepts surrounding API Gateway, Service Mesh, and CNI"
      },
      {
        "role": "user",
        "content": "Write me a 20-word pitch on why I should use a service mesh in my Kubernetes cluster"
      }
    ]
  }'
echo
echo "^^^^"
echo "Alice's request should succeed because she belongs to the dev team."
echo
echo
echo "Testing Bob's access..."
curl -i http://$GATEWAY_IP:8080/qwen -H "Authorization: Bearer $BOB_TOKEN" -H "Content-Type: application/json" -d '{
    "messages": [
      {
        "role": "system",
        "content": "You are a solutions architect for Kubernetes networking, skilled in explaining complex technical concepts surrounding API Gateway, Service Mesh, and CNI"
      },
      {
        "role": "user",
        "content": "Write me a 20-word pitch on why I should use a service mesh in my Kubernetes cluster"
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
  curl -i http://$GATEWAY_IP:8080/qwen \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "messages": [
        {
          "role": "system",
          "content": "You are a solutions architect for Kubernetes networking, skilled in explaining complex technical concepts surrounding API Gateway, Service Mesh, and CNI"
        },
        {
          "role": "user",
          "content": "Write me a 20-word pitch on why I should use a service mesh in my Kubernetes cluster"
        }
      ]
    }'
  echo
done

# Step 12: Cleanup
read -p "Step 12: Cleanup demo resources. Press enter to proceed..."
kubectl delete -f tiered-rate-limit
kubectl delete -f access-control/rbac
kubectl delete -f access-control
kubectl delete -f route
echo "Cleanup completed."
echo

echo "END"
