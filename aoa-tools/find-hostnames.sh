#!/bin/bash

# Function to remove trailing slash from a directory path
remove_trailing_slash() {
  echo "$1" | sed 's:/*$::'
}

# Function to extract HTTPRoute hostnames from manifests
extract_hostnames() {
  echo "$1" | yq eval '.. | select(has("hostnames")).hostnames[]' - || true
}

# Function to validate and filter hostnames
is_valid_hostname() {
  [[ "$1" =~ ^([a-zA-Z0-9][-a-zA-Z0-9]*\.)+[a-zA-Z]{2,}$ ]]
}

# Check if a path argument was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <environment-path>"
  exit 1
fi

# Environment path provided as argument
env_path=$(remove_trailing_slash "$1")  # Normalize the environment path

# Check if the path exists
if [ ! -d "$env_path" ]; then
  echo "Error: The provided path '$env_path' does not exist."
  exit 1
fi

# Initialize hostname list
hostname_list=()

# Find all subdirectories with a kustomization.yaml and run kubectl kustomize
while IFS= read -r kustomization_file; do
  # Normalize the directory path to remove any trailing slashes
  dir=$(dirname "$kustomization_file" | sed 's:/*$::')
  
  # Run kubectl kustomize and capture output
  kubectl_output=$(kubectl kustomize "$dir")
  
  if [ $? -eq 0 ]; then
    # Extract hostnames from the rendered manifests
    hostnames=$(extract_hostnames "$kubectl_output")
    
    if [ -n "$hostnames" ]; then
      # Add each valid hostname to the array
      while IFS= read -r hostname; do
        if is_valid_hostname "$hostname"; then
          hostname_list+=("$hostname")
        fi
      done <<< "$hostnames"
    fi
  fi
done < <(find "$env_path" -type f -name 'kustomization.yaml')

# Remove duplicates and sort the list
unique_hostnames=($(printf "%s\n" "${hostname_list[@]}" | sort -u))

# Print the final list of hostnames
echo "# ===================================="
echo "# Final List of Hostnames:"
for hostname in "${unique_hostnames[@]}"; do
  echo "$hostname"
done
echo "# ===================================="

# Print the one-liner
echo "# In a one-liner:"
printf "%s " "${unique_hostnames[@]}"
echo
