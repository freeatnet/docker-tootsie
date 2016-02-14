FROM alpine:3.3
MAINTAINER Arseniy Ivanov <freeatnet@freeatnet.com>

ENV APP_HOME /srv/tootsie
ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base
ENV RUBY_PACKAGES ruby ruby-io-console
ENV APP_PACKAGES libxml2 libxml2-dev libxslt-dev

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add $APP_PACKAGES && \
    apk add $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/*

RUN gem install --no-rdoc --no-ri bundler

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY tootsie/Gemfile $APP_HOME/
COPY tootsie/Gemfile.lock $APP_HOME/

RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --without development test --deployment

COPY tootsie/* $APP_HOME/
