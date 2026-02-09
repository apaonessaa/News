# Abstract Generator

    docker build --build-arg HF_TOKEN='' --build-arg HF_API='' --tag classifier -f Dockerfile .

    docker run --rm -p 127.0.0.1:8083:8000 --name classifier classifier
    
    curl -i -X POST -H 'Content-Type: application/json' -d @test.json http://localhost:8083/
