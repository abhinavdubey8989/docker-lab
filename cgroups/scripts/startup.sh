#!/bin/sh

# Exit immediately if any command fails.
# This prevents the container from continuing in a partially configured state.
set -e


install_packages() {
    # Installs all Linux utilities required for the container lab
    # [Packages]
    # - stress-ng : Generate CPU, memory, I/O, and process load to experiment with cgroups.
    # - procps    : Provides tools such as ps, top, pgrep, pkill.
    # - util-linux: Provides tools such as lsns, unshare, nsenter, mount, etc.
    # - iproute2  : Provides networking tools such as ip, ss, tc.
    #
    # Using '--no-cache' avoids storing the APK package index inside the image,
    # keeping the container filesystem smaller.
    echo "Installing packages..."

    apk add --no-cache \
        stress-ng \
        procps \
        util-linux \
        iproute2

    echo "Package installation completed"
}


keep_container_alive() {
    
    # Keeps the container alive indefinitely.
    #
    # - Normally a container stays alive only as long as its main process (PID 1) is running
    # - An Alpine container has no long‑running process by default
    # - ie. it starts, runs the default shell (or nothing), and immediately exits.
    # - `tail -f /dev/null` is a harmless, never‑ending command (it just waits for new lines on /dev/null, which never arrives)
    # - Container stays alive forever, unless stopped explicitely
    echo "Container is ready"
    tail -f /dev/null
}


main() {
    install_packages
    keep_container_alive
}


# Call the main function with all arguments
main "$@"