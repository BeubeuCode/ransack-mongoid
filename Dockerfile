FROM ruby:3.3-alpine

RUN apk add --no-cache build-base git

WORKDIR /app

COPY Gemfile ransack-mongoid.gemspec ./
COPY lib/ransack/mongoid/version.rb lib/ransack/mongoid/version.rb

RUN bundle install

COPY . .

CMD ["bundle", "exec", "rspec"]
