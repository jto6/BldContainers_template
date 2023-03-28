#!/bin/bash

# Make sure appuser id matches host's user
USER_ID=${LOCAL_USER_ID:-1000}
if [ "$USER_ID" -ne 1000 ]; then
    echo "Running as UID : $USER_ID"
    usermod -u $USER_ID appuser
fi

# Install build environment

# execute supplied command or default to interactive bash shell
if [ "$#" = 0 ]; then
    exec /usr/sbin/gosu appuser bash
else
    exec /usr/sbin/gosu appuser "$@"
fi
