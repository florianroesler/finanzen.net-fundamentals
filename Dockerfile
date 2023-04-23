FROM ruby:3.2.2-slim-bullseye

RUN apt-get update && apt-get install -y chromium libxml2-dev libxslt-dev make build-essential

RUN gem update --system && gem install bundler && bundle config build.nokogiri --use-system-libraries

ENV APP_HOME=/app \
    BUNDLE_JOBS=4

WORKDIR $APP_HOME

RUN mkdir -p $APP_HOME

COPY Gemfile* $APP_HOME/

RUN bundle install

COPY . $APP_HOME/
