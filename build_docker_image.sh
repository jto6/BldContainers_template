#!/bin/bash
# Script to build builder docker images 

_what_i_build="xxx"
_dname="xxxbuilder"
_docker_registry="ghcr.io/jto6/"

# Should not need to modify below

die() {
    echo "FATAL: $*"
    exit 1
}

usage() {
    echo "Script to build ${_what_i_build} build docker image"
    echo "Usage:"
    echo "  $0 "
    echo "     [-r <docker registry> DEFAULT=${_docker_registry}]"
    exit 0
}

while getopts  r:h arg
do case $arg in
        r)      _docker_registry="$OPTARG";;
        h)      usage;;
        :)      die "$0: Must supply an argument to -$OPTARG.";;
        \?)     die "Invalid Option -$OPTARG ";;
esac
done

# Build build environment image
docker build --network=host -t ${dname } -f Dockerfile .

# Publish docker image
if [[ ! -z ${_docker_registry} ]]; then
    docker tag ${_dname} ${_docker_registry}${_dname}
    docker push ${_docker_registry}${_dname}
fi

echo "Done!!!"
