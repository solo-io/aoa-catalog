% ./dynamic-rl-script.sh 
Step 1: Setting up authentication tokens...
Tokens set.

Enter the API base URL for the portal server backend (e.g., https://api.glootest.com): ^C
alexly-solo@Solo-System-ALy changes-jm % ./dynamic-rl-script.sh
Step 1: Setting up authentication tokens...
Tokens set.

Enter the API base URL for the portal server backend (e.g., https://api.glootest.com): 
No base URL provided. Please try again.
Enter the API base URL for the portal server backend (e.g., https://api.glootest.com): https://api.glootest.com
-------------------------
Step 1 complete. Press enter to proceed to Step 2...

Step 2: Creating a user...
curl -X PUT https://api.glootest.com/v1/me -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN'

User created with ID: 08ec0031-78d7-4097-ab4b-86d5b11d4a2f

-------------------------
Step 2 complete. Press enter to proceed to Step 3...

Step 3: Creating a team for the user...
curl -X POST https://api.glootest.com/v1/teams -H 'Content-Type: application/json' -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN' -d '{"Name": "Test Team", "Description": "description"}'

Team created with ID: 8b0704f4-4805-47e7-967a-795897baa207

-------------------------
Step 3 complete. Press enter to proceed to Step 4...

Step 4: Creating an application for the team...
curl -X POST https://api.glootest.com/v1/teams/$TEAM_ID/apps -H 'Content-Type: application/json' -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN' -d '{"Name": "Test Application", "Description": "description"}'

Application created with ID: 0e38d895-0d9c-4288-b26c-1f6d8c527f6c

-------------------------
Step 4 complete. Press enter to proceed to Step 5...

Step 5: Listing available API products...
curl -X GET https://api.glootest.com/v1/api-products -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN'

Available API Products:
0) Catstronauts Course Tracks (ID: 9cd8deaf-2ea3-44eb-9c79-638fc88bcdff)

Please select an API product by number (0 to 0): 
Invalid selection. Please enter a valid number between 0 and 0.
Please select an API product by number (0 to 0): 0
Selected API Product ID: 9cd8deaf-2ea3-44eb-9c79-638fc88bcdff

-------------------------
Step 5 complete. Press enter to proceed to Step 6...

Step 6: Creating a subscription to the API product...
curl -X POST https://api.glootest.com/v1/apps/$APPLICATION_ID/subscriptions -H 'Content-Type: application/json' -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN' -d '{"ApiProductId": "9cd8deaf-2ea3-44eb-9c79-638fc88bcdff"}'

Full subscription response: 
HTTP Status: 201

Subscription created successfully, but no response body. Skipping subscription ID extraction.
Discovering subscription ID by listing subscriptions...
curl -X GET https://api.glootest.com/v1/apps/$APPLICATION_ID/subscriptions -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN'

Subscription ID: 423be635-c7b9-4e6b-a923-a30a1f7d6ee7

-------------------------
Step 6 complete. Press enter to proceed to Step 7...

Step 7: Approving subscription...
curl -X POST https://api.glootest.com/v1/subscriptions/$SUBSCRIPTION_ID/approve -H 'Authorization: Bearer $ADMIN_USER_AUTH_TOKEN'

Subscription approved.

-------------------------
Step 7 complete. Press enter to proceed to Step 8...

Step 8: Setting a dynamic rate limit for the subscription...
Enter the number of requests per minute: 
Invalid input. Please enter a valid number.
Enter the number of requests per minute: 
Invalid input. Please enter a valid number.
Enter the number of requests per minute: 10
Applying rate limit of 10 requests per MINUTE to subscription 423be635-c7b9-4e6b-a923-a30a1f7d6ee7...

Rate limit applied. Note that the time unit is configurable, but for this demo, it's set to MINUTE.
-------------------------
Step 8 complete. Press enter to proceed to Step 9...

Step 9: Approving the subscription metadata...

Subscription metadata approved.


Step 8: Creating API key...
curl -X POST https://api.glootest.com/v1/apps/$APPLICATION_ID/api-keys -H 'Content-Type: application/json' -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN' -d '{"apiKeyName": "test-key"}'

API Key created: 01b72ec5-6987-4b6e-b5fa-c20bd07fc554
API Key ID: 7c1bafb3-3756-4467-9eca-1e63666ff9ba

-------------------------
Step 9 complete. Press enter to proceed to Step 10...

Step 10: Validating the API key...

curl -X GET https://api.glootest.com/v1/metadata?apiKey=$API_KEY&apiProductId=tracks
{"allowed":true,"customMetadata":{"key2":"value2"},"rateLimit":{"requestsPerUnit":"10","unit":"MINUTE"}}

-------------------------
Step 10 complete. Press enter to proceed to Step 11...

Step 11: Calling the tracks endpoint without the API key (expecting 403)...
curl https://tracks.glootest.com/tracks/c_0
Rejected

Expecting a Rejected - 403 error.

-------------------------
Step 11 complete. Press enter to proceed to Step 12...

Step 12: Calling the tracks endpoint with the API key (expecting 200 responses until rate limit is hit)...
curl https://tracks.glootest.com/tracks/c_0 -H 'x-test-api-key: $API_KEY'
Attempt 1:
HTTP Status Code: 200
-------------------------
Attempt 2:
HTTP Status Code: 200
-------------------------
Attempt 3:
HTTP Status Code: 200
-------------------------
Attempt 4:
HTTP Status Code: 200
-------------------------
Attempt 5:
HTTP Status Code: 200
-------------------------
Attempt 6:
HTTP Status Code: 200
-------------------------
Attempt 7:
HTTP Status Code: 200
-------------------------
Attempt 8:
HTTP Status Code: 200
-------------------------
Attempt 9:
HTTP Status Code: 200
-------------------------
Attempt 10:
HTTP Status Code: 200
-------------------------
Attempt 11:
HTTP Status Code: 429
-------------------------
Expecting dynamic rate limiting after attempt 11.

-------------------------
Step 12 complete. Press enter to proceed to Step 13...

Step 13: Revoking the API key...

curl -X DELETE https://api.glootest.com/v1/api-keys/$API_KEY_ID -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN' -H 'User-Agent: curl/8.9.0' -H 'Accept: */*'

API Key revoked successfully. HTTP Status: 204

-------------------------
Step 13 complete. Press enter to proceed to Step 14...

Step 14: Calling the tracks endpoint with the revoked API key (expecting 403)...
curl https://tracks.glootest.com/tracks/c_0 -H 'x-test-api-key: $API_KEY'
Rejected

Expecting a Rejected - 403 error.

-------------------------
All operations completed successfully!