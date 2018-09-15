FROM ruby:2.3.1-alpine
MAINTAINER from scratch Co.Ltd.

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/f-scratch/circleci-danger"

RUN apk update && apk upgrade && \
  apk add --no-cache bash git sudo openssh && \
  addgroup -g 3434 circleci && \
  adduser -D -u 3434 -G circleci -s /bin/bash circleci && \
  echo 'circleci ALL=NOPASSWD: ALL' > /etc/sudoers

USER circleci

COPY Gemfile* $HOME/target/
COPY Dangerfile $HOME/target/

WORKDIR $HOME/target

RUN gem install bundler --no-document && \
    bundle install --path=vendor/bundle

CMD ["/bin/sh"]
