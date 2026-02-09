# Abstract Generator

    docker build -t summarizer -f Dockerfile .

    docker run --rm -p 127.0.0.1:8082:8000 --name summarizer summarizer

    curl -i -X POST -H 'Content-Type: application/json' -d @test.json http://localhost:8082/
