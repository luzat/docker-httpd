# syntax=docker/dockerfile:1

FROM httpd:2.4.62

ENV HTTPD_DIR=htdocs
ENV HTTPD_HOST=localhost

RUN <<-EOF
  set -xe
  sed -ri 's/^# *(LoadModule (brotli|deflate|expires|http2|proxy|proxy_fcgi|rewrite)_module )/\1/' /usr/local/apache2/conf/httpd.conf
  echo '
ServerName "${HTTPD_HOST}"
DocumentRoot "/var/www/${HTTPD_DIR}"
Protocols h2 h2c http/1.1
<Directory "/var/www/${HTTPD_DIR}">
    DirectoryIndex index.php
    Options -Indexes +FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>

<IfFile conf/server.key>
    <IfFile conf/server.crt>
        LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
        LoadModule ssl_module modules/mod_ssl.so
        Include conf/extra/httpd-ssl.conf
    </IfFile>
</IfFile>

IncludeOptional conf/conf.d/*.conf
' >> /usr/local/apache2/conf/httpd.conf
  sed -ri '
    s!^DocumentRoot ".*"$!DocumentRoot "/var/www/${HTTPD_DIR}"!;
    s/^ServerName [^:]+:443$/ServerName ${HTTPD_HOST}:443/;
    /^(Transfer|Error)Log\s*/d;
    /^CustomLog\s*/,+1d
  ' /usr/local/apache2/conf/extra/httpd-ssl.conf
  mkdir -p /var/www /usr/local/apache2/conf/conf.d
EOF

WORKDIR /var/www

