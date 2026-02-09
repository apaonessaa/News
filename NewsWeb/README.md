# News Web

    docker build --tag newsweb -f Dockerfile . 
    
    docker run --rm -p 8080:80 --name newsweb newsweb
