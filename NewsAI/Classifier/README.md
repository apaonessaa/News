# Abstract Generator

    docker build --build-arg HF_TOKEN='' --build-arg HF_MODEL='' --tag classifier -f Dockerfile .

    docker run --rm -p 8083:8083 --name classifier classifier
    
    curl -i -X POST -H 'Content-Type: application/json' -d @test.json http://localhost:8083/
