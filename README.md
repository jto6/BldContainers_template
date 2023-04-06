# BldContainers_template
Template files for creating a container for a build environment

## Intro
As a template, the basic files needed to create a container for housing a particular build environment are:

1. The container recipe (`Dockerfile`) itself
2. A build script that builds the image.  This may be as simple as the `build` command, but can get more
complex with complex build environments.
3. An install script that at least sets as alias up for invoking the container image (since
the `run` command has so many options to remember).  But also it may setup the corresponding environment
on the Host for persistent build data if it cannot be done with the host setup script run inside the 
container (eg, cloning source code that requires the user's credentials).
4. A Host initialization script that may do further one-time Host setup, but run within the container
(eg, the source code you are building that you will also want to modify).
5. An initialization script to be run each time the container image is invoked.  At least, this is setting
up the user id so that the owner of the build artifacts is the same as the host user invoking the
container.  It may also initialize anything else needed before a build.

## Porting
To create a containerized build environment from these templates:
1. Set names for the container and what it builds (`_what_i_build`, `autoSDbuilder`) in 
`build_docker_image.sh` and `install.sh`
2. Update `Dockerfile` to use the desired base OS, install the necessary packages, and anything else
that can be statically installed for the build environment.
3. Update the Host install script `install.sh` to do any non-container installations, like
clone git repos.
4. Update the container based Host setup script `hostsetup.sh` with any remaining one-time Host
setup.
5. Add any setup needed each time the container is invoked in `entrypoint.sh`.
6. Update the README.md with build and usage instructions for this particular build environment.

## Using

### Building the container
> ./build_docker_image.sh

### Installing the build environment to use the container
> ./install.sh

### Using the build environment
In the installation directory (specified in the installation step):

- Source the .alias file `source .alias`
- Build the project: `<build_container> make [-C <sub_dir>]`
- Or enter the container and execute commands directly: `<build_container>``

### Notes
If working inside the container,
any pushes to the repo need to be made outside the container, as the container does not
have the user's push credentials.

 
