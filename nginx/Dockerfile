FROM nginx:latest

RUN apt-get install -y vim

ADD ./ssl/* /etc/ssl/
ADD ./conf.d/* /etc/nginx/conf.d/
