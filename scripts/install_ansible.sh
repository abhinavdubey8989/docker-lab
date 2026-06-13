#!/bin/bash


# ============================================================================
# [Aim]
# This script will install ansible on a linux based machine
# 
# [Assumptions]
# - This script runs on  Ubuntu 24.04.4 LTS (code-name : noble)
# - It installs
#       - Ansible 14.0.0 (ansible-core 2.21.0)
#
# [Usage]
#  - chmod +x <script>.sh
#  - ./<script>.sh
#
# ============================================================================


set -euo pipefail


# Pin the versions
ANSIBLE_VERSION="14.0.0-1ppa~noble"
ANSIBLE_CORE_VERSION="2.21.0-1ppa~noble"


verify_ansible() {
    # expected result :
    # ii  ansible  14.0.0-1ppa~noble
    # ii  ansible-core  2.21.0-1ppa~noble
    dpkg -l | grep ansible

}


main(){

    echo "📦 Installing prerequisites..."
    sudo apt update -y
    sudo apt install -y \
        software-properties-common \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    echo "🔑 Adding Ansible PPA..."
    sudo add-apt-repository --yes --update ppa:ansible/ansible

    echo "📦 Updating package index..."
    sudo apt update -y

    echo "📦 Installing pinned Ansible..."
    sudo apt install -y \
    ansible=${ANSIBLE_VERSION} \
    ansible-core=${ANSIBLE_CORE_VERSION}

    echo "📌 Holding Ansible version..."
    sudo apt-mark hold ansible ansible-core

    verify_ansible
    echo "🎉 Ansible installation complete"
}


main "$@"