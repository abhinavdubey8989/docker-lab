

# [Aim] : this script will install docker on a linux based machine

# [Sample usage] : "./<script>"


main(){

    # STEP-1 : install docker
    # https://www.youtube.com/watch?v=x6k1wwwN7-0
    # https://cloudchamp.notion.site/How-to-Install-Docker-on-Ubuntu-20-f6cda544c64f44ccb83443f8204b098e

    sudo apt update
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"

    sudo apt update
    sudo apt-get install docker-ce
    docker --version

    sudo systemctl start docker
    sudo systemctl enable docker

    # STEP-2 : install docker-compose
    # https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version


    # install net tools
    sudo apt install net-tools
}


# Call the main function with all arguments
main "$@"