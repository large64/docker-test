FROM ruby:2.3.7

RUN apt-get update && apt-get install php -y

# Install composer
RUN ssh-keyscan github.com > /etc/ssh/ssh_known_hosts \
  && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer
