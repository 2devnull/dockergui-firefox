# Builds a docker gui image
FROM hurricane/dockergui:x11rdp1.3

MAINTAINER 2devnull

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Set environment variables

# User/Group Id gui app will be executed as default are 99 and 100
ENV USER_ID=99
ENV GROUP_ID=100

# Gui App Name default is "GUI_APPLICATION"
ENV APP_NAME="rdp-firefox"

# Default resolution, change if you like
ENV WIDTH=1280
ENV HEIGHT=720

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

RUN \
#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################
echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe restricted' > /etc/apt/sources.list && \
echo 'deb http://archive.ubuntu.com/ubuntu trusty-updates main universe restricted' >> /etc/apt/sources.list && \

# Install packages needed for app
export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive && \
apt-get update && \
apt-get install -y --no-install-recommends \
lxterminal nano firefox && \

apt-get -f install -y --no-install-recommends


# Install steps for X app


# Copy X app start script to right location
COPY startapp.sh /startapp.sh

############################################
## Remove unwated items from base images ###
############################################
RUN \
killall guacd && \
/etc/init.d/tomcat7 stop && \
dpkg --purge tomcat7 && \
dpkg --purge guacamole-server && \
dpkg --purge oracle-java8-set-default oracle-java8-installer


RUN \ 
apt-get clean -y && \
apt-get autoclean -y && \
apt-get autoremove -y && \
rm -rf /usr/share/locale/* && \
rm -rf /var/cache/debconf/*-old && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/doc/* && \
rm -rf /tmp/* /var/tmp/* && \
rm -rf /var/lib/apt/lists/* /var/cache/* && \
rm -rf /var/lib/tomcat7 /usr/share/tomcat7 /etc/service/tomcat7 && \
rm -rf /var/lib/guacamole /etc/service/guacd



#########################################
##         EXPORTS AND VOLUMES         ##
#########################################

# Place whater volumes and ports you want exposed here:
VOLUME ["/config"]
EXPOSE 3389 8080
