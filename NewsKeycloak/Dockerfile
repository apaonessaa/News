FROM quay.io/keycloak/keycloak:latest
ENV KC_BOOTSTRAP_ADMIN_USERNAME=keycloak-admin
ENV KC_BOOTSTRAP_ADMIN_PASSWORD=Password123!
#ENV KC_DB=postgres
#ENV KC_DB_URL_HOST=keycloak-postgres
#ENV KC_DB_URL_DATABASE=keycloak
#ENV KC_DB_USERNAME=keycloak
#ENV KC_DB_PASSWORD=password
EXPOSE 8080
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev"]
