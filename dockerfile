FROM gradle:6.6-jdk

#RUN apt-get update && apt-get install -y \
#python3 \
#&& rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY executeTests2.sh .

CMD ./executeTests2.sh