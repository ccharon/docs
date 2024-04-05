#!/bin/env bash

# This script is used to manage a ZIP Drive on a Linux system. It checks if the necessary module and tools
# are available, and then either activates or deactivates the ZIP Drive based on its current state.
# The user is prompted to take necessary actions before each operation.

# copy this script to /usr/local/bin/zipdrive.sh
# change the permissions to make it executable: chmod 755 /usr/local/bin/zipdrive.sh
# change the owner to root: chown root:root /usr/local/bin/zipdrive.sh

# newer zip drives require the imm module, older zip drives require the ppa module
MODULE_NAME="imm"

# Check if script is run as root
if [ "$EUID" -ne 0 ]
    then echo "Need root privileges to interact with kernel modules ..."
    sudo "$0" "$@"
    exit 0
fi

main() {
    # Sanity checks
    if ! check_module ; then
        echo "The module $MODULE_NAME does not exist. Can not activate Zip Drive. Please make the module available."
        exit 1
    fi

    if ! check_jq ; then
        echo "jq not found, please install jq package for your distribution."
        exit 1
    fi

    # Start / Stop Zip Drive
    if module_loaded; then
        module_deactivate
    else
        module_activate
    fi
}

check_jq() {
    which jq 2>/dev/null 1>&2
    return $?
}

check_module() {
    if [ ! -f "/usr/lib/modules/$(uname -r)/kernel/drivers/scsi/$MODULE_NAME.ko" ]; then
        return 1
    fi
    return 0
}

module_loaded() {
    lsmod | grep "$MODULE_NAME" &> /dev/null
}

module_activate() {
    prompt_user "Activating ZIP Drive. Please power on the ZIP Drive and remove any media from the drive."

    # Get the current timestamp
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    modprobe $MODULE_NAME
    sleep 2

    # Display the system log output since the timestamp
    echo ""
    journalctl -k --since "$TIMESTAMP" -o json | jq -r 'select(.MESSAGE | test("'$MODULE_NAME'|scsi"; "i")) | .MESSAGE'
    echo ""
}

module_deactivate() {
    prompt_user "Deactivating ZIP Drive. Please ensure to unmount any ZIP Disks and remove them from the drive."
    modprobe -r $MODULE_NAME
}

prompt_user() {
    local message=$1
    echo "$message"
    echo "Press any key to continue..."
    read -n 1 -s
}

main "$@" || exit 1
