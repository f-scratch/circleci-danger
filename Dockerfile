FROM ruby:2.7.1-alpine

ARG VCS_REF
ARG BUILD_DATE
LABEL maintainer="from scratch Co.Ltd." \
      org.label-schema.url="https://f-scratch.co.jp" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/f-scratch/circleci-danger"\
      org.label-schema.vcs-ref=$VCS_REF

ENV HOME=/home/circleci

RUN apk update && apk upgrade && \
  apk add --no-cache bash git openssh && \
  addgroup -g 3434 circleci && \
  adduser -D -u 3434 -G circleci -s /bin/bash circleci

USER circleci

COPY --chown=circleci:circleci Gemfile* $HOME/danger/
COPY --chown=circleci:circleci Dangerfile $HOME/danger/
COPY --chown=circleci:circleci Dangerfile4th $HOME/danger/

WORKDIR $HOME/danger

RUN gem install bundler --no-document && \
    bundle install

CMD ["/bin/sh"]
