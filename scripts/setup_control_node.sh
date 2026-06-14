#!/bin/bash


# ============================================================================
# [Aim]
# This script will setup the node from where the ansible & terrafom is run
#
# [Usage]
#  - chmod +x <script>.sh
#  - ./<script>.sh
#
# ============================================================================



set -euo pipefail

main() {

  BASE_DIR="$(dirname "$0")"
  echo "Base dir = $BASE_DIR"

  echo "Installing Ansible..."
  bash "$BASE_DIR/install_ansible.sh"

  echo "Installing Terraform..."
  bash "$BASE_DIR/install_terraform.sh"

  echo "Installing AWS CLI..."
  bash "$BASE_DIR/install_aws_cli.sh"

  echo "Installing docker & adding to group..."
  bash "$BASE_DIR/install_docker.sh.sh"
  bash "$BASE_DIR/add_user_to_docker_group.sh"

  echo "🎉 Control-node setup completed"
}

main "$@"