dockerswift
===========

Simple Dockerfile / config files to run a single-replica Swift node (proxy,
account, container, object server) in a Docker container.

Usage
-----
Build the image:

    docker build -t swift .

Run the container:

    docker run [-d] -p 8080:8080 -v node:/srv/node swift
