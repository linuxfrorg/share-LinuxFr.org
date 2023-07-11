# syntax=docker/dockerfile:1

FROM ruby:3.1.4-alpine3.18 AS base

#RUN apk add --update

FROM base AS dependencies

RUN apk add --update build-base

RUN adduser -D app

USER app

WORKDIR /home/app

COPY Gemfile Gemfile.lock share-linuxfr.gemspec ./

ADD lib ./lib

RUN bundle config set without 'development test' && \
  bundle install --verbose --jobs=3 --retry=3

FROM base

RUN adduser -D app

USER app

WORKDIR /home/app

COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

COPY --chown=app . ./

RUN gem build share-linuxfr.gemspec

RUN gem install share-linuxfr -v 0.1.8

CMD ["bin/share-linuxfr", "run", "--config", "config/share.yml", "--log", "log/share-linuxfr.log", "--output", "log/share-linuxfr.output"]
