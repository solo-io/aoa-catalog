TOKEN=$(curl --request POST "http://git.example.com/api/v4/runners" --form "token=solo-token-123" --form "description=default-runner" --form "run_untagged=true" | jq '.token')

kubectl apply -f runner-role.yaml 

helm repo add gitlab https://charts.gitlab.io
helm repo update gitlab

helm install  gitlab-runner  gitlab/gitlab-runner --set gitlabUrl=http://gitlab  --set rbac.enabled=true --set runnerToken=$TOKEN

