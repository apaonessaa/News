# **Progetto di Sistemi Distribuiti e Cloud Computing**


Admin
- firstname
- lastname
- email

Article
- title
- abstract
- body
- category*
- subcategories[]*
- images[]*
- creation_time
- update_time

Image
- filename
- article*

Category
- name
- subcategories[]*
- description

Subcategory
- name
- category*
- description







---

$ dpkg -i jdk-21_linux-x64_bin.deb
$ curl -s "https://get.sdkman.io" | bash

$ java --version
java 21.0.10 2026-01-20 LTS
Java(TM) SE Runtime Environment (build 21.0.10+8-LTS-217)
Java HotSpot(TM) 64-Bit Server VM (build 21.0.10+8-LTS-217, mixed mode, sharing)


Per la gestione e l'installazione di Spring boot.
# https://sdkman.io/
$ sdk ls springboot
springboot 4.0.2


$ wget https://services.gradle.org/distributions/gradle-9.3.1-bin.zip
$ mkdir /opt/gradle
$ unzip -d /opt/gradle gradle-9.3.1-bin.zip
$ export GRADLE_HOME=/opt/gradle/gradle-9.3.1
$ export PATH=${GRADLE_HOME}/bin:${PATH}
$ gradle --version

------------------------------------------------------------
Gradle 9.3.1
------------------------------------------------------------

Build time:    2026-01-29 14:15:01 UTC
Revision:      44f4e8d3122ee6e7cbf5a248d7e20b4ca666bda3

Kotlin:        2.2.21
Groovy:        4.0.29
Ant:           Apache Ant(TM) version 1.10.15 compiled on August 25 2024
Launcher JVM:  21.0.10 (Oracle Corporation 21.0.10+8-LTS-217)
Daemon JVM:    /usr/lib/jvm/jdk-21.0.10-oracle-x64 (no Daemon JVM specified, using current Java home)
OS:            Linux 6.17.0-12-generic amd64

$ unzip -d . ~/Downloads/api.zip 

$ cd api/
$ gradle build && java -jar build/libs/api-0.0.1-SNAPSHOT.jar