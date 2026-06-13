FROM centos:7

ENV container=docker

# Vault repo CentOS 7
RUN sed -i 's/mirrorlist=/#mirrorlist=/g' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo

RUN yum -y update && \
    yum -y install \
        httpd \
        php \
        php-mysql \
        php-gd \
        php-mbstring \
        php-xml \
        php-cli \
        php-common \
        unzip \
        wget \
        curl \
        git && \
    yum clean all

# Utente Pterodactyl
RUN useradd -m -d /home/container -s /bin/bash container

# Web directory
RUN mkdir -p /home/container/public_html && \
    chown -R apache:apache /home/container

# Apache document root
RUN sed -i 's#/var/www/html#/home/container/public_html#g' \
    /etc/httpd/conf/httpd.conf

# AllowOverride (htaccess)
RUN sed -i 's/AllowOverride None/AllowOverride All/g' \
    /etc/httpd/conf/httpd.conf

#  FIX CRITICO: runtime dir per apache
RUN mkdir -p /run/httpd && \
    chown -R apache:apache /run/httpd

# fix ServerName warning (opzionale ma pulito)
RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf

COPY --chmod=755 entrypoint.sh /entrypoint.sh

WORKDIR /home/container

EXPOSE 80

CMD ["/entrypoint.sh"]
