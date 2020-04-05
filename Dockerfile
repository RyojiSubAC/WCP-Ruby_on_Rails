FROM ruby:2.7.0
RUN apt-get update -qq && apt-get install -y nodejs build-essential vim libpq-dev && rm -rf /var/lib/apt/lists/*

# yarn
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn

# railsコンソール中で日本語入力するための設定
ENV LANG C.UTF-8
RUN mkdir /app
ENV APP_ROOT /app
WORKDIR $APP_ROOT

# gemfileを追加する
COPY ./src/Gemfile $APP_ROOT/Gemfile
COPY ./src/Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install

ADD ./src/ $APP_ROOT
