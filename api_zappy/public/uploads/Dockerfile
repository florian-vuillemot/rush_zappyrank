FROM rails:latest
ENV RAILS_ENV="production"

COPY app /usr/src/app
COPY app/start.sh /usr/src/app/start.sh
RUN chmod +x /usr/src/app/start.sh

WORKDIR /usr/src/app/

RUN bundle install
RUN bundle exec rake assets:precompile
