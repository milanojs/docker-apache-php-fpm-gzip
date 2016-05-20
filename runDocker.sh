#!/bin/bash
DOCKERFOLDER=/var/www/html
LOCALFOLDER/var/www/html
docker run -dP --name apachephp5fpm -v $LOCALFOLDER:$DOCKERFOLDER -p 80:80 apache_php5_fpm-gzip


