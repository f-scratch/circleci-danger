FROM ruby:2.3.1-alpine
MAINTAINER from scratch Co.Ltd.

COPY Gemfile* /target/
WORKDIR /target

RUN apk update && apk upgrade && \
    gem install bundler --no-document && \
    bundle install --path=vendor/bundle

COPY . /target

USER circleci

CMD ["/bin/sh"]
