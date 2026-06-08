#!/bin/bash

# ============================================================================
# [Aim]
# This script will remove the docker container-data dir (ie. `_volume`) from host machine for that docker-compose setup
#
# 
# [Usage]
#    - "./<script> prometheus-server"
#    - "./<script> grafana"
# 
# [Arguments]
#
# - [Arg-1] - DIR name (ie $1)
#           - give DIR name to go to & remove _volume from
# 
# ============================================================================



# Util fn to check if the DIR_NAME & has a docker-compose file
# If valid dir, it returns the DIR name
validate_dir() {
    DIR_NAME=$1

    PROJECT_DIR="$(dirname "$(pwd)")"
    # enable the below log if debugging needed
    # echo "PROJECT_DIR=[$PROJECT_DIR]"

    TARGET_DIR="$PROJECT_DIR/$DIR_NAME"

    # enable the below log if debugging needed
    # echo "TARGET_DIR=[$TARGET_DIR]"

    if [ -z "$DIR_NAME" ]; then
        echo "Directory name is required"
        exit 1
    fi

    if [ ! -d "$TARGET_DIR" ]; then
        echo "Directory does not exist: $TARGET_DIR"
        exit 1
    fi

    if [ ! -f "$TARGET_DIR/docker-compose.yml" ]; then
        echo "docker-compose.yml not found in: $TARGET_DIR"
        exit 1
    fi

    # Return DIR name if all good
    echo "$TARGET_DIR"
}



remove_volume_dir() {
    # remover container-data dir (bind-mount)
    rm -rf _volume
    echo "volume removed !!"

}


create_volume_dir() {
    # create container-data dir (bind-mount)
    mkdir _volume
    echo "volume created !!"
}


main(){
    DIR_NAME=$1

    TARGET_DIR=$(validate_dir "$DIR_NAME")
    cd "$TARGET_DIR" || exit 1
    echo "Inside the DIR=[$TARGET_DIR]"
    remove_volume_dir
    create_volume_dir
}


# Call the main function with all arguments
main "$@"
