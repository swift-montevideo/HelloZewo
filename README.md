# HelloZewo
Server Side Swift example using Zewo components

## What's this?
This is an example of an web app using [Zewo](http://www.zewo.io/) components and standar server-side tools like [Docker](https://www.docker.com/)

## Setup

### Install Swiftenv
[swiftenv](https://github.com/kylef/swiftenv) is a version manager for Swift.

In OSX using [homebrew](http://brew.sh/)
```sh
$ brew install kylef/formulae/swiftenv
```

Setup your shell
```sh
$ echo 'if which swiftenv > /dev/null; then eval "$(swiftenv init -)"; fi' >> ~/.bash_profile
```
> Change `~/.bash_profile` for `~/.zshrc` for ZSH

### Instal Postgre drivers
This project use the [PostgreSQL](https://github.com/Zewo/PostgreSQL) Zewo package. For it to work we need to install the native Postgre drivers. We can do it with homebrew like this:
```sh
$ brew install postgresql
```

### Install Docker
This project use docker to run the databse server. Follow the installation steps for OSX [here](https://www.docker.com/products/docker-toolbox).

To check that you have a working docker installation you can run `docker run hello-world` If that doesn't fail you are ready to continue.
Once you have a working docker installation we need to get a Postgre image from [DockerHub](https://hub.docker.com/). This means we have to run:
```sh
$ docker pull postgres
```

This will download and setup a docker image for us. To start your local Postgres database inside Docker you can try:
```sh
$ docker run --name PSQL -p 5432:5432 posgres -d
$ psql -h PSQL -p 5432 -U postgres
```

The first line start the Postgres server in docker and the second run the native client `psql` from your machine and connect to the docker container.
You can do many other things, che the docs [here](https://hub.docker.com/_/postgres/).

### Clone this repo
Go to a safe place to store this nice example project and run:
```sh
$ git clone https://github.com/swift-montevideo/HelloZewo.git
```

Once it finish `cd` into it and run:
swiftenv install DEVELOPMENT-SNAPSHOT-2016-04-12-a

This will download the Swift beta form Swift.org. This repo is configured (via `.swift-version`) to use that snapshot. When the installation finish try:

## Build
Once you have the project setup the only thing you have to do is tell SPM to build this package. To do so we use:
```sh
$ swift build -Xcc -I/usr/local/include -Xlinker -L/usr/local/lib/
```

This build the package including the headers and library for Postgres

## Run
To run this we first have to start the Postgres container. If you *don't* start the container before then you need to do it now:
```sh
$ docker run --name PSQL -p 5432:5432 posgres -d
```

Once the database server is running start this awesome app with:
```sh
$ sudo .build/debug/hello
```

The `sudo` is needed because it's listen for incoming connections in a port under 1024 (80). As a homework, try to use another port :)

By happy.