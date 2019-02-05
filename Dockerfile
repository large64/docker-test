FROM php:7.2

# Install packages
RUN apt-get update && apt-get install -y ssh git zip unzip wget
RUN pecl install apcu
RUN docker-php-ext-enable apcu

# Install composer
RUN ssh-keyscan github.com > /etc/ssh/ssh_known_hosts \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# Install Apache Thrift
RUN  cd /tmp && wget http://www-us.apache.org/dist/thrift/0.10.0/thrift-0.10.0.tar.gz -O thrift.tar.gz \
     && mkdir -p /tmp/thrift \
     && tar zxf thrift.tar.gz -C /tmp/thrift --strip-components=1 \
     && cd thrift \
     && ./configure \
     && make --jobs 4 \
     && make install \
     && cd /tmp/ && rm -rf /tmp/*
