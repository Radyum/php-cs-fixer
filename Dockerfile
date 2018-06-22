FROM alpine:3.6

# PHP
RUN apk add --no-cache \
        php7

# Performances matter
RUN apk add --no-cache \
        php7-opcache \
        php7-apcu

# cs-fixer requirements
RUN apk add --no-cache \
        php7-phar \
        php7-mbstring \
        php7-openssl \
        php7-json \
        php7-ctype \
        php7-tokenizer \
        php7-posix

RUN echo $'\n\
opcache.enable_cli=1 \n\
opcache.file_cache=/tmp/opcache \n\
opcache.file_update_protection=0 \n'\
>> /etc/php7/conf.d/cs-fixer.ini \

 && mkdir -p /tmp/opcache

# Install cs-fixer
RUN apk add --no-cache \
        curl

RUN curl -s http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar > /usr/local/bin/cs-fixer \
 && chmod +x /usr/local/bin/cs-fixer

# Warmup
RUN cs-fixer \
 && cs-fixer fix || true

VOLUME ["/src"]
WORKDIR /src

ENTRYPOINT ["cs-fixer"]
CMD ["cs-fixer:fix"]
