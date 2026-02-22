FROM quay.io/keycloak/keycloak:latest

# Bootstrap Keycloak admin
ENV KC_BOOTSTRAP_ADMIN_USERNAME=keycloak-admin
ENV KC_BOOTSTRAP_ADMIN_PASSWORD=Password123!

# Front channel settings
ENV KC_HOSTNAME_BACKCHANNEL_DYNAMIC=true
ENV KC_HOSTNAME=http://keycloak:8080/

# Import the configurations
ENV KC_IMPORT=/opt/keycloak/data/import/
COPY ./export /opt/keycloak/data/import/

EXPOSE 8080

# Production: start
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev", "--import-realm"]
