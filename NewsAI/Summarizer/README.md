# Abstract Generator


    docker build -t abstract-generator -f Dockerfile .

    docker run --rm -p 8082:8082 --name abstract-generator abstract-generator

    curl -i -X POST -H 'Content-Type: application/json' -d @test.json http://localhost:8082/
