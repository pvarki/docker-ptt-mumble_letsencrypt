==============================
Mumble server with letsencrypt
==============================

Build::

    docker build --progress plain --target server -t mumbleserver:latest .


First run::

    docker run -d --name mumbleserver -e SERVER_DOMAIN=something.example.com -e SERVER_PASSWORD="some good passphrase" -e SUPERUSER_PASSWORD="even better passphrase" -e CERTBOT_EMAIL="contact@example.com" -p 80:80 -p 64738:64738/tcp -p 64738:64738/udp mumbleserver:latest

Coming back later::

  docker start mumbleserver
