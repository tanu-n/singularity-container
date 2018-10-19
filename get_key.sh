#!/bin/bash

# an16e@my.fsu.edu

set -e

export ETCDCTL_API=3

if [ -f "/go/bin/etcdctl" ]; then
    if [ "$1" != "" ] && [ "$2" != "" ] && [ "$3" != "" ] && [ "$4" != "" ] && [ "$5" != "" ]; then
        res=$(/go/bin/etcdctl --endpoints=$1 --cacert=$2 --cert=$3 --key=$4 get $5)
        readarray -t key <<< "$res"
        if [ "$key[1]" != "" ]; then
            echo "${key[1]}"
        else
            echo "Key is empty! aborting... "
            echo "Failed!"
            exit 1
        fi        
    else
    echo "Requires 5 arguments, aborting system..."
    echo "Failed!"
    exit 1
    fi
else
    echo "/go/bin/etcdctl not found in container, aborting..."
    echo "Failed!"
    exit 1
fi                