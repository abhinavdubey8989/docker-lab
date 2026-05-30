

#!/bin/bash

# ============================================================================
# [Aim]
# This script will start/stop the docker-compose components in a given dir in attach/detach mode
#
# [Assumption]
# Docker is ALREADY installed
#
# [Usage]
#    - "./<script> prometheus-server 1 a"  -> will start in attach mode
#    - "./<script> prometheus-server 1" or "./<script> 1 d"  -> will start in detach-mode
#    - "./<script> prometheus-server 0" -> will stop the container
# 
# [Arguments]
#
# - [Arg-1] - DIR name (ie $1)
#           - give DIR name to go to
# - [Arg-2] - START_STOP_FLAG (ie $1)
#           - (0-> stop , 1-> start)
#           - any other value of this flag is invalid
# - [Arg-3] -to start in attach or detach mode , pass ATTACH_MODE_FLAG (ie $2)
#           - (a-> attach , d-> detach) ,
#           - any other value of this flag is invalid
# 
# ============================================================================


# Util fn to stop docker-compose
stop() {
    docker compose down
    docker container prune -f
    echo "stopped $PWD ..."
}


# Util fn to start docker-compose in attach mode
start_attach() {
    echo "attach mode"
    docker compose up
}


# Util fn to start docker-compose in detach mode
start_detach() {
    echo "detach mode"
    docker compose up -d
}


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


# Util fn to validate START_OR_STOP_FLAG
# If valid flag & its value is 0 (ie. to stop), then it stops & returns
validate_start_or_stop_flag() {
    START_OR_STOP_FLAG=$1

    if [ -z "$START_OR_STOP_FLAG" ]; then
        echo "Invalid value of start/stop flag"
        exit 1

    elif [ "$START_OR_STOP_FLAG" = "0" ]; then
        stop
        exit 0

    elif [ "$START_OR_STOP_FLAG" != "1" ]; then
        echo "Invalid value of start/stop flag"
        exit 1
    fi
}


main(){
    DIR_NAME=$1
    START_OR_STOP_FLAG=$2
    ATTACH_MODE_FLAG=$3

    TARGET_DIR=$(validate_dir "$DIR_NAME")
    cd "$TARGET_DIR" || exit 1
    echo "Inside the DIR=[$TARGET_DIR]"
    validate_start_or_stop_flag "$START_OR_STOP_FLAG"

    # Stop unconditionally first
    # Then, start attach/detach mode
    stop
    if [ -z "$ATTACH_MODE_FLAG" ] || [ "$ATTACH_MODE_FLAG" = "d" ]; then
        start_detach
    elif [ "$ATTACH_MODE_FLAG" = "a" ]; then
        start_attach
    else
        echo "Invalid value of flag"
    fi
}


# Call the main function with all arguments
main "$@"
