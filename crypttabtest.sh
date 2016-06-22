#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

grep -Ev '^$|^#' /etc/crypttab | while read name device password options
do
    if [[ -r "$password" ]]
    then
        cryptsetup luksOpen "$device" --key-file "$password" "$name"
    else
        echo "$password" | cryptsetup luksOpen "$device" "$name"
    fi
done
