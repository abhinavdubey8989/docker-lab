#!/bin/bash

# ============================================================================
# [Aim]
# This script will install docker on a linux based machine
# 
# [Assumptions]
# - This script runs on  Ubuntu 24.04.4 LTS (code-name : noble)
# - It installs
#       - Docker version 29.5.3, build d1c06ef
#       - Docker Compose version v5.1.4
#
# [Usage]
#  - chmod +x <script>.sh
#  - ./<script>.sh
#
# ============================================================================


# The below will exit the script immediately if any command fails
# Prevents partial/broken installations
set -euo pipefail


# Pin the version of docker to be installed
DOCKER_VERSION="5:29.5.3-1~ubuntu.24.04~noble"
DOCKER_CLI_VERSION="5:29.5.3-1~ubuntu.24.04~noble"
DOCKER_COMPOSE_PLUGIN="5.1.4-1~ubuntu.24.04~noble"


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

    echo "📦 Installing prerequisites..."
    sudo apt update -y
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        gnupg \
        lsb-release \
        net-tools


    echo "🔑 Adding Docker keyring repo..."
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

    echo "🐳 Installing Docker ..."
    sudo apt-get install -y \
        docker-ce=${DOCKER_VERSION} \
        docker-ce-cli=${DOCKER_CLI_VERSION} \
        containerd.io \
        docker-buildx-plugin

    echo "📌 Pinning Docker Engine versions ..."
    sudo apt-mark hold \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin

    
    echo "🧩 Installing Compose ..."
    sudo apt-get install -y docker-compose-plugin=${DOCKER_COMPOSE_PLUGIN}

    echo "📌 Pinning Compose version ..."
    sudo apt-mark hold docker-compose-plugin


    enable_docker
    verify_docker
}


# Call the main function with all arguments
main "$@"