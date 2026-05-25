#!/bin/bash

# ============================================================================
# [Aim]
# Allow docker commands without sudo
#
# [Assumption]
# Docker is ALREADY installed
#
# [Usage]
#  - chmod +x <script>.sh
#  - ./<script>.sh
#
# [What this script does]
#   - Adds current user to docker group & allow docker commands without sudo
#   - By default, ubuntu user is not a part of docker group
#   - You can verify this by running : `getent group docker`
# 
# ============================================================================


# Exit immediately if any command fails
# Prevents partial/broken configuration
set -e


main() {

    # Add currently logged-in user to docker group
    # This allows running: docker ps, 
    # instead of: sudo docker ps
    sudo usermod -aG docker "$USER"


    # This refreshes Linux group permission
    # so docker commands work without sudo
    newgrp docker

    sleep 2

    # List the groups of which current user is a part of
    # Expected output : `ubuntu : ubuntu adm cdrom sudo dip lxd docker`
    # ie. user is part of docker group
    echo "Listing groups where [$USER] is a member ..."
    groups $USER


    # List the member in the group called docker
    # `getent` Short for: get entries
    # Expected output : docker:x:988:ubuntu
    # Format          : [group_name]:[password_placeholder]:[GID]:[members]
    # Query the Linux system database and fetch information about the docker group
    docker:x:988:ubuntu
    echo "Listing members of the group docker ..."
    getent group docker
}


# Execute main function
main "$@"