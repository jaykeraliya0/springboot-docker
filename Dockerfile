FROM openjdk:8-jdk-alpine

RUN apk add --no-cache curl tar bash

ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"

RUN mkdir -p /usr/share/maven && \
  curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC /usr/share/maven --strip-components=1 && \
  ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ./ /usr/src/app
RUN mvn clean install -Dmaven.test.skip=true

EXPOSE 8086
CMD ["java", "-jar", "/usr/src/app/target/spring-boot-mysql-docker.jar"]