FROM nginx:latest

WORKDIR /etc/nginx/

ADD ssl ssl

ADD default.conf conf.d/default.conf

ADD www /usr/share/nginx/html
