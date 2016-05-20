FROM ubuntu:14.04
MAINTAINER Juan Milano <juan_milano@hotmail.com>

# Surpress Upstart errors/warning
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive


# Add the Multiverse repositories
RUN /bin/echo '##### Multiverse Repo' >> /etc/apt/sources.list && \
/bin/echo 'deb http://archive.ubuntu.com/ubuntu/ trusty multiverse' >> /etc/apt/sources.list && \
/bin/echo 'deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse'  >> /etc/apt/sources.list && \
/bin/echo 'deb http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse'  >> /etc/apt/sources.list && \
/bin/echo 'deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse'  >> /etc/apt/sources.list

# Update base image and Install software requirements

RUN apt-get update && \
apt-get upgrade -y && \
BUILD_PACKAGES="apache2 libapache2-mod-fastcgi php5-fpm php5 php5-curl php5-gd php5-imagick" && \
apt-get -y install $BUILD_PACKAGES && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean && \
rm -r /var/lib/apt/lists/*

# Enable Apache Mods
RUN a2enmod actions fastcgi alias deflate

#Add config file for php5-fpm
ADD ./php5/php-fpm.conf /etc/php5/fpm/
ADD ./php5/pool.d/www.conf /etc/php5/fpm/pool.d/

#Add config file for php5-fpm in mods available apache
ADD ./apache2/conf-available/php5-fpm.conf /etc/apache2/conf-available/

# Enable apache autostart
RUN update-rc.d apache2 enable

# Enable php5-fpm
RUN update-rc.d php5-fpm enable

# add test PHP file
RUN rm /var/www/html/index.html
ADD ./index.php /var/www/html/
RUN chown -Rf www-data.www-data /var/www/html/
RUN chmod a+x /var/www/html/index.php

# Expose Ports
EXPOSE 80

# Running apache2 and php5 fpm
CMD service apache2 start
CMD service php5-fpm start
