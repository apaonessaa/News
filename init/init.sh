#!/bin/bash

CATEGORY_ENDPOINT='http://localhost:8080/api/categories'
FILE_TO_READ="$PWD/init.json"

if [ ! -f "$FILE_TO_READ" ]; then
    echo "Il file $FILE_TO_READ non esiste."
    exit 1
fi

### Create the Category
CATEGORIES=$(jq -r '.[].name' "$FILE_TO_READ")

# Usa un ciclo per iterare correttamente sulle categorie (ogni nome viene trattato come un'unica stringa, anche se contiene spazi)
while IFS=$'\n' read -r cat; do
    cat_descr=$(jq -r --arg cat "$cat" '.[] | select(.name==$cat) | .description' "$FILE_TO_READ")

    # Create Category
    curl -s "$CATEGORY_ENDPOINT" \
        -X POST \
        --header 'Content-Type: application/json' \
        -d @- <<EOF 
{"name": "$cat","description": "$cat_descr","subcategories": []}
EOF
    
    sleep 1

    ### Create the Subcategories
    SUBCATEGORIES=$(jq -r --arg cat "$cat" '.[] | select(.name==$cat) | .sub[] | .name' "$FILE_TO_READ")

    while IFS=$'\n' read -r subcat; do
        subcat_descr=$(jq -r --arg cat "$cat" --arg subcat "$subcat" \
        '.[] | select(.name == $cat) | .sub[] | select(.name == $subcat) | .description' "$FILE_TO_READ")

        # Create Subcategory
        curl -s "$CATEGORY_ENDPOINT/$cat/subcategories" \
            -X POST \
            --header 'Content-Type: application/json' \
            -d @- <<EOF 
{"name": "$subcat","description": "$subcat_descr", "category": "$cat", "articles": []}
EOF
    done <<< "$SUBCATEGORIES"

done <<< "$CATEGORIES"