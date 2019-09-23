ARG RUBY_IMAGE=ruby:2.6.2-alpine3.9
ARG PACKAGES='build-base'

FROM $RUBY_IMAGE

ARG PACKAGES
RUN apk add --update --no-cache $PACKAGES

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --without development test -j4 --retry 3 \
 # Remove unneeded files (cached *.gem, *.o, *.c)
 && rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . .
