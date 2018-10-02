# docker-httpd

This is a customized docker image of Apache based on the official images. It is used for providing a local development environment.

**Please note:** This is mostly used internally, but I am happy if anyone finds this useful or provides improvements.

## Features

* Commonly used modules are enabled:
  * `deflate`
  * `expires`
  * `http2` (protocols `h2` and `h2c` already enabled)
  * `proxy`
  * `proxy_fcgi`
  * `rewrite`
* Configurability:
  * `*.conf` taken from `/usr/local/apache2/conf/conf.d` (samples in [conf.d](conf.d))
  * host name taken from `$HTTPD_HOST` (default: `localhost`)
  * subdirectory of `/var/www` taken from `$HTTPD_DIR` (default: `htdocs`)
* Optional SSL support:
  * requires `server.crt` and `server.key` in `/usr/local/apache2` 

## Getting started

See [luzat/template-php](https://github.com/luzat/template-php) for example usage.

## Author

**Thomas Luzat** - [luzat.com](https://luzat.com/)

## License

This project is licensed under the [ISC License](LICENSE.md).
