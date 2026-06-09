#!/bin/bash


# ============================================================================
# [Aim]
# This script will install ansible on a linux based machine
# 
# [Assumptions]
# - This script runs on  Ubuntu 24.04.4 LTS (code-name : noble)
# - It installs : AWS CLI
#
# [Usage]
#  - chmod +x <script>.sh
#  - ./<script>.sh
#
# ============================================================================


set -euo pipefail


verify_aws_cli(){
    # Expected result : aws-cli/2.34.64 Python/3.14.5 Linux/6.17.0-1012-aws exe/x86_64.ubuntu.24
    aws --version
}

remove_aws_zip(){
    # Remove the unzipped `aws` dir & zip file
    rm -rf aws*
}


main(){
    sudo apt update
    sudo apt install -y unzip curl

    # Get the
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    sleep 2
    remove_aws_zip
    verify_aws_cli
    echo "🎉 AWS CLI installation complete"
}


main "$@"
