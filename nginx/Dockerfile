FROM nginx:latest

RUN mkdir -p /etc/ssl
ADD ./ssl/ /etc/
ADD ./conf.d/* /etc/nginx/conf.d/
