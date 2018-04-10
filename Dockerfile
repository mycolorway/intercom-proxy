FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y --force-yes \
  build-essential

ENV APP_HOME=/app \
  BUNDLE_JOBS=8 \
  BUNDLE_PATH=/bundle

RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.org

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock

RUN bundle install

COPY . $APP_HOME
