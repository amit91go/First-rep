FROM gradle:5.4.1-jdk8-alpine as builder
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle shadowJar

FROM amazoncorretto:8u212
COPY --from=builder /home/gradle/src/build/libs/imagesapi.jar /usr/jar/sample.jar
WORKDIR /usr/jar
EXPOSE 6789
CMD ["java", "-jar", "sample.jar"]