# README

    docker build --tag newsdb -f Dockerfile .

    docker run --rm -p 3306:3306 --name newsdb newsdb

    docker exec -it newsdb bash -l

   mysql -u root -proot newsdb 
