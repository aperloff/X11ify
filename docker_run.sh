#!/bin/bash

usage="./docker_run.sh \"<options> -e DISPLAY=<display>\" \"<image_name>:<image_tag>\" \"<cmd>\""

docker_options=${1:-""}
docker_image=${2:-""}
docker_cmd=${3:-""}

if [[ "${docker_options}" != *"-e DISPLAY="* ]]; then
    echo "WARNING::You didn't set a display variable using the docker options. Make sure the appropriate variable is available inside the container."
    echo -e "\tExample (OSX): DISPLAY=host.docker.internal:0"
fi

# Capture the output of the xhost command and look for the lines:
#  "access control enabled, only authorized clients can connect"
#  "INET:localhost
# If the first is different, then the xhost access should be reset by doing:
#  xhost -
# Then check again. If either the second line is missing, or the first was there, but the second one was missing, then do:
#  xhost +127.0.0.1
# Then check again. If it's not right this time, then exit and throw an error
xhost_enabled="access control enabled, only authorized clients can connect"
xhost_localhost="INET:localhost"
xhost_check="$(xhost)"
if [[ $xhost_check == *"${xhost_localhost}"* ]]; then
    echo "Note::access control already enabled, including an opening for localhost"
else
    xhost -
    xhost_check="$(xhost)"
    if [[ $xhost_check != *"${xhost_enabled}"* ]]; then
        xhost +127.0.0.1
        xhost_check="$(xhost)"
        if [[ $xhost_check != *"${xhost_localhost}"* ]]; then
            echo "ERROR:Unable to set the xhost settings properly"
        fi
    fi
fi

if [[ -z ${docker_options} ]] || [[ -z ${docker_image} ]]; then
    if [[ -z ${docker_options} ]]; then
	echo "ERROR::The docker options statement was empty."
	echo -e "\t${usage}"
    fi
    if [[ -z ${docker_image} ]]; then
	echo "ERROR::The docker image parameter was empty."
	echo -e "\t${usage}"
    fi
else
    (set -x
     docker run ${docker_options} ${docker_image} ${docker_cmd}
    )
fi
