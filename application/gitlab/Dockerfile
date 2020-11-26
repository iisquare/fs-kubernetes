FROM harbor.iisquare.com/library/jdk:8

ARG APP_NAME
ARG APP_VERSION

MAINTAINER Ouyang "iisquare@163.com"

RUN yum -y install kde-l10n-Chinese && yum -y reinstall glibc-common
RUN echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ADD ${APP_NAME}/target/${APP_NAME}-${APP_VERSION}.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar", "--server.port=8080"]
