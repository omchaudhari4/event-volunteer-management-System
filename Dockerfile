# Use JDK 8 base image
FROM openjdk:8-jdk-alpine

WORKDIR /app

# Copy repository content into image
COPY . /app

# Compile Java files into webapp/WEB-INF/classes
RUN mkdir -p webapp/WEB-INF/classes && \
    find src -name "*.java" > sources.txt && \
    javac -cp "lib/*:webapp/WEB-INF/lib/*" -d webapp/WEB-INF/classes @sources.txt && \
    cp src/db.properties webapp/WEB-INF/classes/db.properties

# Expose server port
EXPOSE 8080

# Run server on container start
CMD ["sh", "-c", "java -cp 'webapp/WEB-INF/classes:lib/*:webapp/WEB-INF/lib/*' com.event.server.MainServer && java -jar lib/jetty-runner.jar --port 8080 webapp"]
