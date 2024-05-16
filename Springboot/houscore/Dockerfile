#FROM ubuntu:latest
#LABEL authors="SSAFY"

# 베이스 이미지 지정
FROM openjdk:17.0.1

# 포트 지정
EXPOSE 8084

# JAR 파일을 이미지 내부로 복사
COPY build/libs/houscore-springboot-app-0.1.0.jar /houscore-springboot-app.jar

# 도커 컨테이너에서 실행할 명령어
ENTRYPOINT ["java","-jar","/houscore-springboot-app.jar"]