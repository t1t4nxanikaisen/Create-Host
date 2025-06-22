FROM ubuntu:24.10
LABEL maintainer="wingnut0310 <wingnut0310@gmail.com>"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV GOTTY_TAG_VER v1.0.1

RUN apt-get -y update && \
    apt-get install -y curl && \
    curl -sLk https://cdimage.ubuntu.com/ubuntu-base/releases/24.10/release/ubuntu-base-24.10-base-amd64.tar.gz\
    | tar xzC /usr/local/bin && \
    apt-get purge --auto-remove -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists*


COPY /run_gotty.sh /run_gotty.sh

RUN chmod 744 /run_gotty.sh

EXPOSE 8080

CMD ["/bin/bash","/run_gotty.sh"]
