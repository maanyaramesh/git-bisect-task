FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    git \
    bash \
 && rm -rf /var/lib/apt/lists/*

RUN pip install pytest

WORKDIR /workspace

COPY . /workspace

RUN git config --global user.email "test@example.com"
RUN git config --global user.name "Test User"