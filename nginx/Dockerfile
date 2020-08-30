FROM nginx:latest

RUN mkdir -p /etc/ssl
ADD ./ssl/ /etc/
ADD ./sites-available /etc/nginx/

RUN rm -f /etc/nginx/sites-enabled/*

RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
