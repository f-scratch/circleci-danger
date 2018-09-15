FROM ruby:2.3.1-alpine
MAINTAINER from scratch Co.Ltd.

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/f-scratch/circleci-danger"

COPY Gemfile* /target/
WORKDIR /target

RUN apk update && apk upgrade && \
    gem install bundler --no-document && \
    bundle install --path=vendor/bundle

RUN apk add --no-cache bash git sudo openssh && \
  addgroup -g 3434 circleci && \
  adduser -D -u 3434 -G circleci -s /bin/bash circleci && \
  echo 'circleci ALL=NOPASSWD: ALL' > /etc/sudoers

COPY . /target

USER circleci

CMD ["/bin/sh"]
