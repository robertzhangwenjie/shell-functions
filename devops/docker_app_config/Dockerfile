FROM hub.sofadev.res.aliyun-test.sdebank.com/library/openjdk:8-jdk-alpine

WORKDIR /home/admin
COPY target/*.jar .
COPY ./start.sh .
RUN sed -i 's/\r//' ./start.sh
ENTRYPOINT [ "/bin/sh", "/home/admin/start.sh", "start" ]
