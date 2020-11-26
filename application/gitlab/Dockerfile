FROM harbor.iisquare.com/library/jdk:8

ARG APP_NAME
ARG APP_VERSION

MAINTAINER Ouyang "iisquare@163.com"

ADD ${APP_NAME}/target/${APP_NAME}-${APP_VERSION}.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar", "--server.port=8080"]
