This images provides a basic php 7.1 fpm installation with xdebug. The
default fpm port here is 9999 to prevent a conflict with the xdebug
port 9000.

The `app.env.dist` file is an example for an `app.env` file which you
can use with `docker-compose`. The configuration in this file enables
xdebug for WEB and CLI debugging by default.

For CLI you need to configure your IDE of your choice with the key
provided by `PHP_IDE_CONFIG=serverName=app_host`. In our example here,
`app_host` is the key.
