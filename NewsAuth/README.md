# NewsKeycloak

## Export Keycloak settings

    $ docker exec [CONTAINER_ID] /opt/keycloak/bin/kc.sh export --dir=/tmp/export --users=different_files --optimized

    $ docker cp [CONTAINER_ID]:/tmp/export .
