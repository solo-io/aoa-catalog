TOKEN=$(curl -k -H 'Private-token: solo-token-123' -X POST 'http://git.example.com/api/v4/user/runners?runner_type=instance_type&description=main&run_untagged=true' | jq -r '.token')
kubectl apply -f runner-role.yaml 

helm repo add gitlab https://charts.gitlab.io
helm repo update gitlab

helm install  gitlab-runner  gitlab/gitlab-runner --set gitlabUrl=http://gitlab  --set rbac.enabled=true --set runnerToken=$TOKEN

