#!/bin/bash

# Make sure blduser id matches host's user
USER_ID=${LOCAL_USER_ID:-1000}
if [ "$USER_ID" -ne 1000 ]; then
    echo "Running as UID : $USER_ID"
    usermod -u $USER_ID blduser
fi

# Install build environment

# execute supplied command or default to interactive bash shell
if [ "$#" = 0 ]; then
    exec /usr/sbin/gosu blduser bash
else
    exec /usr/sbin/gosu blduser "$@"
fi

or remove all the user_id and gosu stuff if using the docker run -u option.
