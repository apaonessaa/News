# Corrector

    docker build --build-arg HF_TOKEN='' --build-arg HF_API='' --build-arg HF_MODEL='' --tag corrector -f Dockerfile .

    docker run --rm -p 127.0.0.1:8083:8000/tcp --name corrector corrector
    
    curl -i -X POST -H 'Content-Type: application/json' -d @test.json http://localhost:8083/
