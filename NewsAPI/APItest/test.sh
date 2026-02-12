#!/bin/bash

curl -i -X POST --header 'Content-Type: application/json' --data '{"name":"Mondo", "description": "Il mondo è fatto di fatti, avvenimenti e tutto ciò che può assomigliare a qualcosa di strano e insospettabilmente sano.", "subcategories":[]}' http://localhost:8081/api/categories

curl -i -X POST --header 'Content-Type: application/json' --data '{"name":"Europa", "description": "EU deriva da EUropa.", "category":"Mondo", "articles":[]}' http://localhost:8081/api/categories/Mondo/subcategories

curl -i -X POST --header 'Content-Type: application/json' --data $'{"name":"Stati Uniti d\'America", "description": "Maledetti USA. Usa e getta.", "category":"Mondo", "articles":[]}' http://localhost:8081/api/categories/Mondo/subcategories

