FROM debian:9.5-slim
#FROM ubuntu:latest

LABEL "com.github.actions.name"="Hello World"
LABEL "com.github.actions.description"="Write arguments to the standard output"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="http://github.com/octocat/hello-world"
LABEL "homepage"="http://github.com/actions"
LABEL "maintainer"="Octocat <octocat@github.com>"

# prepare a user which runs everything locally! - required in child images!
RUN useradd --user-group --create-home --shell /bin/false app
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    wget \
    context \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/jgm/pandoc/releases/download/2.2.1/pandoc-2.2.1-1-amd64.deb
RUN dpkg -i pandoc-2.2.1-1-amd64.deb  && rm pandoc-*.deb
#Cleanup to reduce container size
RUN apt-get remove -y wget && \ 
    apt-get autoclean && \
    apt-get clean

ENV APP_NAME=resume


ADD entrypoint.sh /entrypoint.sh

# RUN chmod +x /entrypoint.sh

#ENTRYPOINT ["/entrypoint.sh"]
RUN make all
RUN echo "All done"
