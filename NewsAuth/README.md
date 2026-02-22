# NewsKeycloak

## Export Keycloak settings

    $ docker exec [CONTAINER_ID] cp -rp /opt/keycloak/data/h2 /tmp

    $ docker exec [CONTAINER_ID] /opt/keycloak/bin/kc.sh export --db dev-file --db-url 'jdbc:h2:file:/tmp/h2/keycloakdb;NON_KEYWORDS=VALUE' --dir=/tmp/export --users=same_file --optimized

    $ docker cp [CONTAINER_ID]:/tmp/export .
