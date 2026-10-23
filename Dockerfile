FROM tomcat:9.0
COPY target/jenkins-docker-cicd.war /usr/local/tomcat/webapps/
EXPOSE 8080
