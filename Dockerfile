FROM centos:7

MAINTAINER custom <support@local>

ENV container=docker

# Fix repo CentOS 7
RUN sed -i 's/mirrorlist=/#mirrorlist=/g' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo

# Install Apache + PHP 5.4 + tools
RUN yum -y update && \
    yum -y install httpd php php-mysql php-gd php-mbstring php-xml php-cli php-common \
    curl wget git unzip tar bash && \
    yum clean all

# Pterodactyl user (MANDATORY)
RUN adduser -d /home/container container

# Workdir
WORKDIR /home/container

# Web root
RUN mkdir -p /home/container/public_html

# -----------------------------
# Apache HARD FIX for containers
# -----------------------------
RUN mkdir -p /tmp/apache /var/run/httpd /var/log/httpd

RUN sed -i 's#/var/www/html#/home/container/public_html#g' /etc/httpd/conf/httpd.conf && \
    sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf && \
    echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf && \
    echo "PidFile /tmp/httpd.pid" >> /etc/httpd/conf/httpd.conf && \
    echo "ErrorLog /tmp/error_log" >> /etc/httpd/conf/httpd.conf && \
    echo "CustomLog /tmp/access_log combined" >> /etc/httpd/conf/httpd.conf

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
