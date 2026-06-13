# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: PHP 5.4 Apache (CentOS 7)
# ----------------------------------
FROM centos:7

MAINTAINER custom, <support@local>

ENV container=docker

# Fix CentOS 7 repo
RUN sed -i 's/mirrorlist=/#mirrorlist=/g' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo

# Install dependencies (single layer, clean)
RUN yum -y update && \
    yum -y install httpd php php-mysql php-gd php-mbstring php-xml php-cli php-common \
        curl wget git unzip tar bash && \
    yum clean all

# ----------------------------------
# Creating a Container User (MANDATORY)
# ----------------------------------
RUN adduser -d /home/container container

# ----------------------------------
# Work Directory
# ----------------------------------
WORKDIR /home/container

# App directory
RUN mkdir -p /home/container/public_html

# Fix Apache docroot
RUN sed -i 's#/var/www/html#/home/container/public_html#g' /etc/httpd/conf/httpd.conf && \
    sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf && \
    echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf

# CRITICAL FIX: move runtime outside /run
RUN echo "PidFile /tmp/httpd.pid" >> /etc/httpd/conf/httpd.conf && \
    echo "ErrorLog /tmp/error_log" >> /etc/httpd/conf/httpd.conf

# ----------------------------------
# Entrypoint
# ----------------------------------
COPY ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
