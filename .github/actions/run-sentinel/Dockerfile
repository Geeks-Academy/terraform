FROM thrashr888/sentinel-simulator

LABEL "com.github.actions.name"="sentinel test"
LABEL "com.github.actions.description"="Test Sentinel policies"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/rberlind/sentinel-policy-sets-for-tfc"
LABEL "homepage"="http://github.com/rberlind/sentinel-policy-sets-for-tfc"
LABEL "maintainer"="Roger Berlind"

# RUN apk --no-cache add jq curl
RUN apt update -y
RUN apt-get install -y jq curl

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["."]