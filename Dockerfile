FROM ubuntu:14.04
MAINTAINER Juan Milano <juan_milano@hotmail.com>

# Surpress Upstart errors/warning
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
# ENV DEBIAN_FRONTEND noninteractive

# Add the Multiverse repositories
RUN
echo 'deb http://archive.ubuntu.com/ubuntu/ trusty multiverse' > /etc/apt/sources.list && \
echo 'deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse'  > /etc/apt/sources.list && \
echo 'deb http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse'  > /etc/apt/sources.list && \
echo 'deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse'  > /etc/apt/sources.list && \


# Update base image
# Install software requirements

RUN apt-get update && \
apt-get update && \
apt-get upgrade -y && \
BUILD_PACKAGES="apache2-mpm-event libapache2-mod-fastcgi php5-fpm php5 php5-curl php5-gd php5-imagick" && \
apt-get -y install $BUILD_PACKAGES && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean && \
rm -r /var/lib/apt/lists/*


#Add config file for php5-fpm

#Add config file for php5-fpm in mods available apache


RUN mkdir -p /etc/varnish/sites
ADD default.vcl /etc/varnish/default.vcl


# Supervisor Config
ADD ./supervisord.conf /etc/supervisord.conf


# Setup Volume
#VOLUME ["/usr/share/nginx/html"]

# add test PHP file
#ADD ./index.php /usr/share/nginx/html/index.php
#RUN chown -Rf www-data.www-data /usr/share/nginx/html/

# Expose Ports
#EXPOSE 443
EXPOSE 80

CMD ["/bin/bash", "/start.sh"]
