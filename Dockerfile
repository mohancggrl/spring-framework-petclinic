FROM centos as git
RUN yum update -y
RUN yum install git -y
WORKDIR /tmp/
RUN git clone --single-branch --branch dev https://github.com/mohancggrl/spring-framework-petclinic.git

FROM maven as maven
RUN mkdir /usr/src/mymaven
WORKDIR /usr/src/mymaven
COPY --from=git /tmp/spring-framework-petclinic .
RUN mvn clean package -DskipTests

FROM tomcat
WORKDIR webapps
COPY --from=maven /usr/src/mymaven/target/*.war .
RUN rm -rf ROOT && mv *.war ROOT.war
