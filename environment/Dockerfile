FROM ubuntu:22.04

RUN apt-get update && apt-get install -y git bash

WORKDIR /workspace

RUN mkdir repo
WORKDIR /workspace/repo

RUN git init

RUN git config user.email "test@example.com"
RUN git config user.name "Tester"

# good commit
RUN echo '#!/bin/bash\nexit 0' > check.sh && \
    chmod +x check.sh && \
    git add check.sh && \
    git commit -m "initial working version"

# another good commit
RUN echo "hello" > README.md && \
    git add README.md && \
    git commit -m "add readme"

# bad commit
RUN echo '#!/bin/bash\nexit 1' > check.sh && \
    chmod +x check.sh && \
    git add check.sh && \
    git commit -m "introduce failing behavior"