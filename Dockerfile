FROM ruby:2.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /flashcardbot
WORKDIR /flashcardbot
ADD Gemfile /flashcardbot/Gemfile
ADD Gemfile.lock /flashcardbot/Gemfile.lock
RUN bundle install
ADD . /flashcardbot

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]
