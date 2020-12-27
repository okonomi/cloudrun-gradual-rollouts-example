FROM ruby:3.0.0-rc1-slim

WORKDIR /app
RUN apt-get update -y && apt-get install -y --no-install-recommends build-essential libsqlite3-dev
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install
ADD . .
RUN mkdir tmp log

CMD bin/rails s -b 0.0.0.0 -p $PORT
