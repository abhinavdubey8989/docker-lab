
# [Aim] : this script will start/stop the docker-compose component

# [Arg-1] : START_STOP_FLAG (ie $1)
#       - (0-> stop , 1-> start)
#       - any other value of this flag is invalid

# [Arg-2] to start in attach or detach mode , pass ATTACH_MODE_FLAG (ie $2)
#       - (a-> attach , d-> detach) ,
#       - any other value of this flag is invalid

# [Sample usage]
#       - "./<script> 1 a"  -> will start in attach mode
#       - "./<script> 1" or "./<script> 1 d"  -> will start in detach-mode
#       - "./<script> 0" -> will stop the container


stop() {
    docker compose down
    docker container prune -f
    echo "stopped $PWD ..."
}


start_attach() {
    echo "attach mode"
    docker compose up
}


start_detach() {
    echo "detach mode"
    docker compose up -d
}


main(){
    START_OR_STOP_FLAG=$1
    ATTACH_MODE_FLAG=$2

    if [ -z "$START_OR_STOP_FLAG" ] ; then
        echo "Invalid value of start/stop flag"
        exit 0
    elif [ "$START_OR_STOP_FLAG" = "0" ]; then
        stop
        exit 0
    elif [ "$START_OR_STOP_FLAG" != "1" ]; then
        echo "Invalid value of start/stop flag"
        exit 0
    fi


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
