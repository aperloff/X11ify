ARG IMAGEBASE
FROM ${IMAGEBASE}

USER root

# Install all of the X11 dependencies
# We install the xorg-x11-apps just to verify the installation
# We could just install xorg-x11-apps and trust yum to pick up the dependencies, but where is the fun in that?
RUN yum install -y dejavu-fonts-common dejavu-sans-fonts fontconfig fontpackages-filesystem freetype \
    		   libICE libSM libX11 libX11-common libXau libXaw libXcursor libXext libXfixes libXft \
		   libXmu libXpm libXrender libXt libXxf86vm libfontenc libpng libxcb libxkbfile \
		   xorg-x11-apps \
  && yum clean all \
  && rm -rf /tmp/.X*
