FROM php:7.2

# Install packages
RUN apt-get update && apt-get install -y ssh git zip unzip wget mysql-client gnupg \
  apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Install PHP extensions
RUN pecl install apcu
RUN docker-php-ext-enable apcu
RUN docker-php-ext-install -j$(nproc) mysqli pcntl pdo pdo_mysql

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

# Install docker

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  xenial \
  stable"
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Install docker-compose

RUN curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
