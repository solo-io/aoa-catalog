% ./dynamic-rl-script.sh 
Step 1: Setting up authentication tokens...
Tokens set.

Enter the API base URL for the portal server backend (e.g., https://api.glootest.com): https://api.glootest.com
-------------------------
Step 1 complete. Press enter to proceed to Step 2...

Step 2: Creating a user...
curl -X PUT https://api.glootest.com/v1/me -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN'

User created with ID: 201126a4-7fd9-44ee-9729-b01609ee17c5

-------------------------
Step 2 complete. Press enter to proceed to Step 3...
Choose a team name or enter a custom one:
1) Engineering
2) Marketing
3) Sales
4) Custom
#? 1
Choose a team description or enter a custom one:
1) The engineering team  3) The sales team
2) The marketing team    4) Custom
#? 1

Team created with ID: 210e1555-d4f0-4fe5-b921-26e1587ae7f7

-------------------------
Step 3 complete. Press enter to proceed to Step 4...
Choose an application name or enter a custom one:
1) TestApp1
2) DemoApp
3) ProdApp
4) Custom
#? 1
Choose an application description or enter a custom one:
1) App for testing   3) Production app
2) Demo application  4) Custom
#? 1

Application created with ID: 7b2c69ee-d57e-4a2b-ba39-b038a20bbc3f

-------------------------
Step 4 complete. Press enter to proceed to Step 5...

Step 5: Listing available API products...
curl -X GET https://api.glootest.com/v1/api-products -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN'

Available API Products:
0) Catstronauts Course Tracks (ID: cc233088-93b3-4087-bdc5-393e8624f637)

Please select an API product by number (0 to 0): 0
Selected API Product ID: cc233088-93b3-4087-bdc5-393e8624f637

-------------------------
Step 5 complete. Press enter to proceed to Step 6...

Step 6: Creating a subscription to the API product...
curl -X POST https://api.glootest.com/v1/apps/$APPLICATION_ID/subscriptions -H 'Content-Type: application/json' -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN' -d '{"ApiProductId": "cc233088-93b3-4087-bdc5-393e8624f637"}'

Full subscription response: 
HTTP Status: 201

Subscription created successfully, but no response body. Skipping subscription ID extraction.
Discovering subscription ID by listing subscriptions...
curl -X GET https://api.glootest.com/v1/apps/$APPLICATION_ID/subscriptions -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN'

Subscription ID: 65920b5e-dfd7-4c3a-88e7-480564fb1aa4

-------------------------
Step 6 complete. Press enter to proceed to Step 7...

Step 7: Approving subscription...
curl -X POST https://api.glootest.com/v1/subscriptions/$SUBSCRIPTION_ID/approve -H 'Authorization: Bearer $ADMIN_USER_AUTH_TOKEN'

Subscription approved.

-------------------------
Step 7 complete. Press enter to proceed to Step 8...

Step 8: Setting a dynamic rate limit for the subscription...
Enter the number of requests per minute: 2
Applying rate limit of 2 requests per MINUTE to subscription 65920b5e-dfd7-4c3a-88e7-480564fb1aa4...

Rate limit applied. Note that the time unit is configurable, but for this demo, it's set to MINUTE.
-------------------------
Step 8 complete. Press enter to proceed to Step 9...
Choose an API key name or enter a custom one:
1) TestKey
2) ProdKey
3) DevKey
4) Custom
#? 1

API Key created: adc2f190-a938-44d4-8aff-d6c9ce091150
API Key ID: 9c131b6c-fb3a-4104-b51b-20d8e5719c6d

-------------------------
Step 9 complete. Press enter to proceed to Step 10...

Step 10: Creating API key...
curl -X POST https://api.glootest.com/v1/apps/$APPLICATION_ID/api-keys -H 'Content-Type: application/json' -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN' -d '{"apiKeyName": "test-key"}'

API Key created: b0f2d9a5-c139-484b-bb94-a3433c6a6f75
API Key ID: f2e525e1-ca9d-4d93-843a-030774a99ef1

-------------------------
Step 10 complete. Press enter to proceed to Step 11...

Step 11: Validating the API key...
Enter the API Product ID (e.g., tracks): 
No API Product ID provided. Please try again.
Enter the API Product ID (e.g., tracks): tracks

curl -X GET https://api.glootest.com/v1/metadata?apiKey=$API_KEY&apiProductId=$API_PRODUCT_ID
{"allowed":true,"customMetadata":{"key2":"value2"},"rateLimit":{"requestsPerUnit":"2","unit":"MINUTE"}}

-------------------------
Step 11 complete. Press enter to proceed to Step 12...

Step 12: Calling the tracks endpoint without the API key (expecting 403)...
curl https://tracks.glootest.com/tracks/c_0
Rejected

Expecting a Rejected - 403 error.

-------------------------
Step 12 complete. Press enter to proceed to Step 13...

Step 13: Calling the tracks endpoint with the API key (expecting 200 responses until rate limit is hit)...
curl https://tracks.glootest.com/tracks/c_0 -H 'x-test-api-key: $API_KEY'
Attempt 1:
HTTP Status Code: 200
-------------------------
Attempt 2:
HTTP Status Code: 200
-------------------------
Attempt 3:
HTTP Status Code: 429
-------------------------
Expecting dynamic rate limiting after attempt 3.

-------------------------
Step 13 complete. Press enter to proceed to Step 14...

Step 14: Revoking the API key...

curl -X DELETE https://api.glootest.com/v1/api-keys/$API_KEY_ID -H 'Authorization: Bearer $DEV_USER_AUTH_TOKEN' -H 'User-Agent: curl/8.9.0' -H 'Accept: */*'

API Key revoked successfully. HTTP Status: 204

-------------------------
Step 14 complete. Press enter to proceed to Step 15...

Step 15: Calling the tracks endpoint with the revoked API key (expecting 403)...
curl https://tracks.glootest.com/tracks/c_0 -H 'x-test-api-key: $API_KEY'
Rejected

Expecting a Rejected - 403 error.

-------------------------
All operations completed successfully!