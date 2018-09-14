FROM ruby:2.3.1-alpine
MAINTAINER from scratch Co.Ltd.

COPY Gemfile* /target/
WORKDIR /target

RUN apk update && apk upgrade && \
    gem install bundler --no-document && \
    bundle install --path=vendor/bundle

RUN groupadd --gid 3434 circleci && \
    useradd --uid 3434 --gid circleci --shell /bin/bash --create-home circleci && \
    echo 'circleci ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-circleci && \
    echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep

COPY . /target

USER circleci

CMD ["/bin/sh"]
