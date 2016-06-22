#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Get crypttab content, without commented or empty lines
grep -Ev '^$|^#' /etc/crypttab | while read name device password options
do
    # If password is a file assume it is a key file
    if [[ -r "$password" ]]
    then
        cryptsetup luksOpen "$device" --key-file "$password" "$name"
    else
        # Unlock using plaintext password
        echo "$password" | cryptsetup luksOpen "$device" "$name"
    fi
done
