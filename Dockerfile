FROM centos:7

ENV container=docker

# Usa i vault repository
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

# Cartella web
RUN mkdir -p /home/container/public_html && \
    chown -R apache:apache /home/container

# Apache punta a public_html
RUN sed -i 's#/var/www/html#/home/container/public_html#g' \
    /etc/httpd/conf/httpd.conf

# AllowOverride per .htaccess (CakePHP)
RUN sed -i 's/AllowOverride None/AllowOverride All/g' \
    /etc/httpd/conf/httpd.conf

COPY --chmod=755 entrypoint.sh /entrypoint.sh

WORKDIR /home/container

EXPOSE 80

CMD ["/entrypoint.sh"]
