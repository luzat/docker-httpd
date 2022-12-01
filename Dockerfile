FROM httpd:2.4.54

ENV \
  HTTPD_DIR=htdocs \
  HTTPD_HOST=localhost

RUN set -xe; \
  sed -ri 's/^#*(LoadModule (deflate|expires|http2|proxy|proxy_fcgi|rewrite)_module )/\1/' /usr/local/apache2/conf/httpd.conf; \
  echo '\
ServerName "${HTTPD_HOST}"\n\
DocumentRoot "/var/www/${HTTPD_DIR}"\n\
Protocols h2 h2c http/1.1\n\
<Directory "/var/www/${HTTPD_DIR}">\n\
    DirectoryIndex index.php\n\
    Options -Indexes +FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>\n\
\n\
<IfFile conf/server.key>\n\
    <IfFile conf/server.crt>\n\
        LoadModule socache_shmcb_module modules/mod_socache_shmcb.so\n\
        LoadModule ssl_module modules/mod_ssl.so\n\
        Include conf/extra/httpd-ssl.conf\n\
    </IfFile>\n\
</IfFile>\n\
\n\
IncludeOptional conf/conf.d/*.conf\n'\
    >> /usr/local/apache2/conf/httpd.conf; \
  sed -ri '\
    s!^DocumentRoot ".*"$!DocumentRoot "/var/www/${HTTPD_DIR}"!; \
    s/^ServerName [^:]+:443$/ServerName ${HTTPD_HOST}:443/; \
    /^(Transfer|Error)Log\s*/d; \
    /^CustomLog\s*/,+1d' \
    /usr/local/apache2/conf/extra/httpd-ssl.conf; \
  mkdir -p /var/www /usr/local/apache2/conf/conf.d

WORKDIR /var/www

