#!/bin/bash
# Simple script to setup the build environment

_what_i_build="xxx"
_dname="xxxbuilder"
_docker_registry="ghcr.io/jto6/"
_install_dir=~/Dev

die() {
    echo "FATAL: $*"
    exit 1
}

usage() {
    echo "Install ${_what_i_build} Build env"
    echo "Usage:"
    echo "  $0 "
    echo "     [-d <installation directory> DEFAULT={$_install_dir}]"
    echo "     [-r <docker registry> DEFAULT={$_docker_registry}]"
    exit 0
}

while getopts :t:d:r:h arg
do case $arg in
        d)      _install_dir="$OPTARG";;
        r)      _docker_registry="$OPTARG";;
        h)      usage;;
        :)      die "$0: Must supply an argument to -$OPTARG.";;
        \?)     die "Invalid Option -$OPTARG ";;
esac
done

# Create installation directory
_install_dir="${_install_dir}/${_what_i_build}"
[[ -d ${_install_dir} ]] && die "Installation directory ${_install_dir} already exists.  Aborted install."
mkdir -p ${_install_dir}

# Clone source
# Note this cannot be done inside the container since the container does not have the user's
# credentials.
cd ${_install_dir}
git clone xxx.git

# Run container's host setup scripts to populate persistent data
# Do not map home directory as hostsetup.sh may copy original home content to the
# persistent home directory (eg, .bashrc etc)
docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` --network host\
       -e http_proxy -e https_proxy -e no_proxy \
       -v ${_install_edk2_dir}:/app \
       ${_docker_registry}${_dname} /usr/local/bin/hostsetup.sh
[[ $? == 0 ]] || { echo "Docker runtime not installed or hub not available. Exiting."; exit -1; }

# Setup command aliases
echo
echo "alias ${_what_i_build}_builder='docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` --privileged "\
     "--network host -e http_proxy -e https_proxy -e no_proxy "\
     "-v ${_install_dir}:/app "\
     "-v $HOME:$HOME "\
     "${_docker_registry}${_dname}'" >> ${_install_dir}/.alias
  
# Print example actions
echo "Please run following command to create ${_what_i_build}_builder alias:"
echo "  source  ${_install_dir}/.alias"; echo
echo "Then run the command ${_what_i_build}_builder"