#!/bin/bash

# ============================================================================
# [Aim]
# This script will install docker on a linux based machine
#
# [Usage]
#  - chmod +x <script>.sh
#  - ./<script>.sh
#
# ============================================================================


# The below will exit the script immediately if any command fails
# Prevents partial/broken installations
set -e


verify_docker(){

    # These should work without sudo
    docker --version
    docker compose version
}


enable_docker(){
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo systemctl status docker --no-pager
}




main(){


    # tells Ubuntu package installers: Never ask interactive questions
    export DEBIAN_FRONTEND=noninteractive

    sudo apt update -y
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        gnupg \
        lsb-release \
        net-tools


    echo "Creating docker keyring directory..."
    sudo install -m 0755 -d /etc/apt/keyrings

    echo "Adding Docker GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


    echo "Updating package index with Docker repo..."
    sudo apt-get update -y

    echo "Installing Docker..."
    sudo apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin


    enable_docker
    verify_docker
}


# Call the main function with all arguments
main "$@"