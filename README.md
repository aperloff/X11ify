# X11ify

Build on top of an existing Docker image to add X11 capabilities.

## Build

After cloning or downloading this repository:
```bash
cd X11ify
docker build -t <new_image_name>:<new_image_tag> --build-arg IMAGEBASE=<base_image_name>:<base_image_tag> .
```
In the above command, replace `<new_image_name>`, `<new_image_tag>`, `<base_image_name>`, `<base_image_tag>` with the desired values.

## Run

Unix-like OS often have a program called `xhost`, which is a server access control program for X. It allows the user to add an delete hostnames which are allowed to make connections to the X server. We will need to ensure that the localhost loopback address (127.0.0.1) is allowed to connect to the X server.

To check the status of the xhost access control and the list of allowed hostnames, simply enter the command `xhost`. If access control is enabled, you will see the following message:
```bash
access control enabled, only authorized clients can connect
```
If the localhost has been added to the list of authorized hostnames, you will also see:
```bash
INET:localhost
```
If you don't see that message, the localhost must be added to the list of authorized clients by entering the command:
```bash
xhost +127.0.0.1
```
If you are having problems, it's often helpful to reset the list of authorized clients and start again. On some systems that can be accomplished by turning off access control and turning it back on:
```bash
xhost + # Turns off access control
xhost - # Turns on access control
```
On other systems you must manually remove the hosts and add them back again.


Once the system will allow the localhost to connect to X, you can start the docker container by doing:
```bash
docker run -it -e DISPLAY=<display_variable> ... <image_name>:<image_tag>
```
where `...` is the rest of your usual `docker run` command. You must ensure that the `DISPLAY` variable inside the container is appropriately connected to that of the host. For OSX the display variable is `host.docker.internal:0`, but the variable may be different on other OS.
(Optionally, a command to run inside the container like `/bin/bash` can be appended to this command.)

## Use X11

Once inside the container you should immediately be able to display graphics using X11. You can test this by running `xeyes`. This should display a window with two eyes whose pupils move as you move the cursor.

## Convenience

For your convenience, the script `docker_run.sh` will take care of checking that you set a `DISPLAY` environment variable, assuring that the xhost settings are appropriate, and then running the docker image. The script takes three positional parameters:
   1. The full list of docker run options you'd like to use (i.e. `"-it -e DISPLAY=<display_variable>"`)
   2. The image you'd like to use (i.e. `"<image_name>:<image_tag>"`)
   3. (optional) A command to add to the end of the `docker run` statement (i.e. `/bin/bash`)

Running this script will look something like:
```bash
./docker_run.sh "<options> -e DISPLAY=<display>" "<image_name>:<image_tag>" "<cmd>"
```
where `"<cmd>"` is optional.