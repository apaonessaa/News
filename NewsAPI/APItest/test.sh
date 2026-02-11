#!/bin/bash

curl -i -X POST --header 'Content-Type: application/json' --data '{"name":"world", "description": "The word is World.", "subcategories":[]}' http://localhost:8081/api/categories

curl -i -X POST --header 'Content-Type: application/json' --data '{"name":"europe", "description": "EU stands for Europe.", "category":"world", "articles":[]}' http://localhost:8081/api/categories/world/subcategories

curl -i -X POST http://localhost:8081/api/articles \
  -H "Content-Type: multipart/form-data" \
  -F 'article=@article.json;type=application/json' \
  -F 'image=@./cat.png'

