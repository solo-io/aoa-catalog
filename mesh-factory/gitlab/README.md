
# Setup 
add git.example.com to /etc/hosts

# admin password
kubectl exec deploy/gitlab -- grep 'Password:' /etc/gitlab/initial_root_password