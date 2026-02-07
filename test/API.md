# API Endpoint


    curl -i -X POST --header 'Content-Type: application/json' --data '{"name":"world", "description": "The word is World."}' http://localhost:8180/api/categories
    
    curl -i -X GET http://localhost:8180/api/categories/world

    curl -i -X POST --header 'Content-Type: application/json' --data '{"name":"europe", "description": "EU stands for Europe.", "category":"world"}' http://localhost:8180/api/categories/world/subcategories
    
    curl -i -X GET http://localhost:8180/api/categories/world/subcategories/europe

    curl -i -X POST http://localhost:8180/api/articles \
  -H "Content-Type: multipart/form-data" \
  -F 'article=@article.json;type=application/json' \
  -F 'image=@./cat.png'
   
  wget 'http://localhost:8180/api/articles/New%20Article%20Title/image' -O test.png
  
  curl -i -X POST http://localhost:8180/api/articles \
  -H "Content-Type: multipart/form-data" \
  -F 'article=@article.json;type=application/json' \
  -F 'image=@./cat.jpeg'
  
  curl -i -X DELETE 'http://localhost:8180/api/articles/New%20Article%20Title'


article.json
{
  "title": "New Article Title",
  "summary": "Summary of the article",
  "content": "Content of the article",
  "image":"cat.png",
  "category": "world",
  "subcategories": ["europe"]
}

