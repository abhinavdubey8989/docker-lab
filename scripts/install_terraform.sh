#!/bin/bash


# ============================================================================
# [Aim]
# This script will install ansible on a linux based machine
# 
# [Assumptions]
# - This script runs on  Ubuntu 24.04.4 LTS (code-name : noble)
# - It installs
#       - Terraform v1.15.5
#
# [Usage]
#  - chmod +x <script>.sh
#  - ./<script>.sh
#
# ============================================================================


set -euo pipefail


# Pin version
TERRAFORM_VERSION="1.15.5-1"


verify_terraform(){
    # Expected result : Terraform v1.15.5 on linux_amd64
    terraform -version
}

main(){

    echo "📦 Installing prerequisites..."
    sudo apt update -y
    sudo apt install -y \
        gnupg \
        software-properties-common \
        curl \
        lsb-release


    echo "🔑 Adding HashiCorp GPG key..."
    sudo install -m 0755 -d /etc/apt/keyrings

    curl -fsSL https://apt.releases.hashicorp.com/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/hashicorp.gpg


    sudo chmod a+r /etc/apt/keyrings/hashicorp.gpg


    echo "📡 Adding HashiCorp repository..."
    echo \
        "deb [signed-by=/etc/apt/keyrings/hashicorp.gpg] \
        https://apt.releases.hashicorp.com \
        $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null


    echo "🔄 Updating package index..."
    sudo apt update -y


    echo "📦 Installing pinned Terraform version..."
    sudo apt install -y terraform=${TERRAFORM_VERSION}


    echo "📌 Holding Terraform version..."
    sudo apt-mark hold terraform

    verify_terraform
    echo "🎉 Terraform installation complete"
}

main "$@"