FROM mongo:latest

ARG TOPIC_ARN_ARG
ENV TOPIC_ARN=${TOPIC_ARN_ARG}

RUN apt update
RUN apt-get -y install awscli jq

COPY ./mongodb.sh /
RUN chmod +x /mongodb.sh

ENTRYPOINT [ "./mongodb.sh" ]