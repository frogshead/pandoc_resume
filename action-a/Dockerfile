FROM debian:bookworm-slim

LABEL "com.github.actions.name"="Convert CV to PDF"
LABEL "com.github.actions.description"="Build PDF from Markdown via Pandoc and ConTeXt"
LABEL "com.github.actions.icon"="file-text"
LABEL "com.github.actions.color"="purple"

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    wget \
    context \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/jgm/pandoc/releases/download/3.8.3/pandoc-3.8.3-1-amd64.deb && \
    dpkg -i pandoc-3.8.3-1-amd64.deb && \
    rm pandoc-*.deb

# Cleanup to reduce container size
RUN apt-get remove -y wget && \
    apt-get autoclean && \
    apt-get clean

ENV APP_NAME=resume


ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
