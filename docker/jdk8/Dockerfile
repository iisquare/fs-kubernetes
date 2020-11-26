FROM centos:7

MAINTAINER Ouyang "iisquare@163.com"

ENV  LANG="en_US.UTF-8"
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

ADD jdk-8u111-linux-x64.tar.gz /opt/

ENV JAVA_HOME=/opt/jdk1.8.0_111
ENV JRE_HOME=$JAVA_HOME/jre
ENV CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin

ENTRYPOINT ["java", "-version"]
