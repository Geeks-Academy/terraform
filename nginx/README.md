# NGINX
## Wildcard case
Wildcard is certificate for subdomains ```*.programmers-only.pl```

### SSL

Place your SSL ```certificate.crt``` and ```certificate.key``` in ```./ssl``` directory.

### New subdomains

1. Copy one of existing files in ```./conf.d/``` with name of subdomain.
2. Change ```server_name``` value to desired.
3. Build new docker image.

## Single certificate case
Single certificate is given only for URLs like ```programmers-only.pl```

### SSL

Place your SSL ```*.crt``` and ```*.key``` in ```./ssl``` directory.

1. Copy one of existing files in ```./conf.d/``` with name of domain.
2. Change ```server_name``` value to desired.
3. Add certificate in ```./ssl``` directory.
4. Change ```ssl_certificate``` path values to desired.
5. Build new docker image.
