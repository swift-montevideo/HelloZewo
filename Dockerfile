FROM zewo/docker:0.2.1

ENV APP_NAME=hello

WORKDIR /$APP_NAME/

ADD ./Package.swift /$APP_NAME/
ADD ./Sources /$APP_NAME/Sources

RUN swift build -c release

EXPOSE 8080

CMD .build/release/$APP_NAME
