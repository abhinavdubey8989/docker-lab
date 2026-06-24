#!/bin/bash

# ============================================================================
# [Aim]
# This script will start/stop the docker-compose components in a given dir in attach/detach mode
#
#
# [Assumption]
# - Docker is installed
#
#
# [Arguments]
# --file=<dir_name>
#     Uses <dir_name>/docker-compose.yml
#
# --file=<dir_name>/<compose_file>
#     Uses the specified compose file
#
# --action=<0|1>
#     [0] -> stop
#     [1] -> start
#
# --mode=<a|d>
#     [a] -> attach mode
#     [d] -> detach mode (default)
#
# --volume-clear=true
#        [true]              -> remove compose-managed volumes of current docker-compose only
#        [any-other-value] -> preserve compose-managed volumes (default)
#
# --prune-dangling-volumes=true
#        [true]              -> run `docker volume prune` to remove dangling volums
#        [any-other-value]   -> not run `docker volume prune`
#
#
#
# [Examples]
#
#
# Starting file named : docker-compose.yml
# ./start_stop.sh --file=prometheus-server --action=1 --mode=a
# ./start_stop.sh --file=prometheus-server --action=1 --mode=d
#
#
# Starting a custom yml file (here, `d1.yml`)
# ./start_stop.sh --file=prometheus-server/d1.yml --action=1
# ./start_stop.sh --file=prometheus-server/d1.yml --action=1 --mode=a
#
#
# Stopping (--mode is not needed for stopping)
# ./start_stop.sh --file=prometheus-server --action=0 --volume-clear=true
# ./start_stop.sh --file=prometheus-server/d1.yml --action=0 --prune-dangling-volumes=true
#
# ============================================================================


# Util fn to stop docker-compose
stop() {
    COMPOSE_FILE=$1

    if [ "$GL_VOLUME_CLEAR" = "true" ]; then
        echo "Stopping and removing compose volumes..."
        docker compose -f "$COMPOSE_FILE" down -v
    else
        echo "Stopping and keeping compose volumes..."
        docker compose -f "$COMPOSE_FILE" down
    fi

    docker container prune -f

    if [ "$GL_PRUNE_DANGLING_VOLUMES" = "true" ]; then
        echo "Pruning dangling docker-volumes..."
        docker volume prune -f
    else
        echo "Skipping dangling docker volumes prune operation..."
    fi

    echo "stopped $PWD/$COMPOSE_FILE ..."
}


# Util fn to start docker-compose in attach mode
start_attach() {
    COMPOSE_FILE=$1
    echo "attach mode, for $COMPOSE_FILE"
    docker compose -f "$COMPOSE_FILE" up
}


# Util fn to start docker-compose in detach mode
start_detach() {
    COMPOSE_FILE=$1
    echo "detach mode, for $COMPOSE_FILE"
    docker compose -f "$COMPOSE_FILE" up -d
}


# Util fn to parse the first argument.
#
# Supported formats:
#
# Case-1:
#   dir_name/docker-compose-custom.yml
#
#   Returns:
#     dir_name|docker-compose-custom.yml
#
# Case-2:
#   dir_name
#
#   Returns:
#     dir_name|docker-compose.yml
#
# If no "/" is present, docker-compose.yml is assumed.
parse_dir_and_compose_file() {
    FILE_PATH=$1

    if [ -z "$FILE_PATH" ]; then
        echo "Directory name is required"
        exit 1
    fi

    if [[ "$FILE_PATH" == */* ]]; then
        DIR_NAME="${FILE_PATH%%/*}"
        COMPOSE_FILE_NAME="${FILE_PATH#*/}"
    else
        DIR_NAME="$FILE_PATH"
        COMPOSE_FILE_NAME="docker-compose.yml"
    fi

    echo "$DIR_NAME|$COMPOSE_FILE_NAME"
}


# Util fn to check if the DIR_NAME & has the require docker-compose file
# If valid dir, it returns the DIR name (only the dir name, without the docker yml file name)
validate_dir() {
    FILE_PATH=$1

    PARSED_DIR_AND_FILE=$(parse_dir_and_compose_file "$FILE_PATH")

    # seggregate the dir & file-name
    DIR_NAME="${PARSED_DIR_AND_FILE%%|*}"
    COMPOSE_FILE_NAME="${PARSED_DIR_AND_FILE#*|}"

    CURRENT_PROJECT_DIR="$(dirname "$(pwd)")"

    # TARGET_DIR is the directory where the compose.yml file present
    TARGET_DIR="$CURRENT_PROJECT_DIR/$DIR_NAME"

    # Check if TARGET_DIR valid & compose.yml exists
    if [ -z "$DIR_NAME" ]; then
        echo "Directory name is required"
        exit 1
    fi

    if [ ! -d "$TARGET_DIR" ]; then
        echo "Directory does not exist: $TARGET_DIR"
        exit 1
    fi

    if [ ! -f "$TARGET_DIR/$COMPOSE_FILE_NAME" ]; then
        echo "$COMPOSE_FILE_NAME not found in: $TARGET_DIR"
        exit 1
    fi

    # Return DIR name if all good
    echo "$TARGET_DIR"
}


# Util fn to validate START_OR_STOP_FLAG
# If valid flag & its value is 0 (ie. to stop), then it stops & returns
validate_action() {
    START_OR_STOP_FLAG=$1

    if [ -z "$START_OR_STOP_FLAG" ]; then
        echo "START_OR_STOP_FLAG is required"
        exit 1
    fi

    if [ "$START_OR_STOP_FLAG" != "0" ] && [ "$START_OR_STOP_FLAG" != "1" ]; then
        echo "Invalid START_OR_STOP_FLAG: [$START_OR_STOP_FLAG]"
        echo "Allowed values: 0 (stop), 1 (start)"
        exit 1
    fi
}


# This fn parses the key passed as arg to the script
# and sets the global vars, these vars begin with prefix `GL_`
parse_args() {
    for arg in "$@"; do
        case $arg in
            --file=*)
                GL_FILE_PATH="${arg#*=}"
                ;;
            --action=*)
                GL_ACTION="${arg#*=}"
                ;;
            --mode=*)
                GL_ATTACH_MODE_FLAG="${arg#*=}"
                ;;
            --volume-clear=*)
                GL_VOLUME_CLEAR="${arg#*=}"
                ;;
            --prune-dangling-volumes=*)
                GL_PRUNE_DANGLING_VOLUMES="${arg#*=}"
                ;;
            *)
                echo "Unknown argument: $arg"
                exit 1
                ;;
        esac
    done
}

main(){

    # Set global vars, will be used later in main fn
    parse_args "$@"

    # validate the start-stop flag value
    validate_action "$GL_ACTION"

    # Validate the FILE_PATH given
    # Validity criteria : dir exists & has the required yml file inside it
    # If valid path, goto that dir
    VALIDATED_DIR=$(validate_dir "$GL_FILE_PATH")
    cd "$VALIDATED_DIR" || exit 1
    echo "Inside the DIR=[$VALIDATED_DIR]"


    # invoke parse_dir_and_compose_file & seggregate the dir & file-name
    # This is needed again, since `validate_dir only`` returns the dir name to goto, not the yml file to run
    # in start/stop fn, we need to pass the yml file name, this calling parse_dir_and_compose_file again
    PARSED_DIR_AND_FILE=$(parse_dir_and_compose_file "$GL_FILE_PATH")
    COMPOSE_FILE_NAME="${PARSED_DIR_AND_FILE#*|}"


    # Stop if flag=0
    if [ "$GL_ACTION" = "0" ]; then
        stop "$COMPOSE_FILE_NAME"
        exit 0
    fi

    # If flag=1, start (in attach/detach mode)
    if [ -z "$GL_ATTACH_MODE_FLAG" ] || [ "$GL_ATTACH_MODE_FLAG" = "d" ]; then
        # Start in attach mode (after stopping)
        stop "$COMPOSE_FILE_NAME"
        start_detach "$COMPOSE_FILE_NAME"
    elif [ "$GL_ATTACH_MODE_FLAG" = "a" ]; then
        # Start in detach mode (after stopping)
        stop "$COMPOSE_FILE_NAME"
        start_attach "$COMPOSE_FILE_NAME"
    else
        echo "Invalid value of flag"
    fi
}


# Call the main function with all arguments
main "$@"
