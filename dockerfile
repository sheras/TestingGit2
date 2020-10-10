FROM gradle:6.6-jdk

WORKDIR /build

COPY executeTests.sh .

CMD ./executeTests.sh