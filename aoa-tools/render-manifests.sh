#!/bin/bash

# Function to remove trailing slash from a directory path
remove_trailing_slash() {
  echo "$1" | sed 's:/*$::'
}

# Function to print verbose environment details
print_environment_details() {
  local env_path="$1"
  echo "# ===================================="
  echo "# Processing environment: $env_path"
  echo "# ------------------------------------"
  echo "# Date: $(date)"
  echo "# ===================================="
}

# Function to prompt for output file path
prompt_output_file() {
  read -p "Would you like to save the output to a file? (y/n): " save_output
  if [[ "$save_output" == "y" || "$save_output" == "Y" ]]; then
    read -p "Enter the full path to the output file: " output_file
  fi
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

# Initialize output_file as empty
output_file=""

# Prompt user for output file path
prompt_output_file

# Define a function to handle output redirection
output() {
  if [ -z "$output_file" ]; then
    # If no output file, just print to console
    echo "$1"
  else
    # Print to both console and file
    echo "$1" | tee -a "$output_file"
  fi
}

# Print environment details
output "$(print_environment_details "$env_path")"

# Find all subdirectories with a kustomization.yaml and run kubectl kustomize
find "$env_path" -type f -name 'kustomization.yaml' | while read -r kustomization_file; do
  # Normalize the directory path to remove any trailing slashes
  dir=$(dirname "$kustomization_file" | sed 's:/*$::')
  
  output "# ------------------------------------"
  output "# Found kustomization.yaml in: $dir"
  output "# Running 'kubectl kustomize'..."
  
  # Run kubectl kustomize and capture output
  kubectl_output=$(kubectl kustomize "$dir")
  
  if [ $? -ne 0 ]; then
    output "# Error running 'kubectl kustomize' in $dir"
  else
    output "# Successfully ran 'kubectl kustomize' in $dir"
    output "# ------------------------------------"
    output "# Kustomized output for $dir:"
    output "---"
    output "$kubectl_output"
    output "---"
    output "# ------------------------------------"
  fi
done
