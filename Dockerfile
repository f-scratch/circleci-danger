FROM ruby:2.3.1-alpine

MAINTAINER from scratch Co.Ltd.
LABEL org.label-schema.vcs-url="https://github.com/f-scratch/circleci-danger"

ENV HOME=/home/circleci

RUN apk update && apk upgrade && \
  apk add --no-cache bash git openssh && \
  addgroup -g 3434 circleci && \
  adduser -D -u 3434 -G circleci -s /bin/bash circleci && \
  echo 'circleci ALL=NOPASSWD: ALL' > /etc/sudoers

USER circleci

COPY --chown=circleci:circleci Gemfile* $HOME/danger/
COPY --chown=circleci:circleci Dangerfile $HOME/danger/

WORKDIR $HOME/danger

RUN gem install bundler --no-document && \
    bundle install

CMD ["/bin/sh"]
