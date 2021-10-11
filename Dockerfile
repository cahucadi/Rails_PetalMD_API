FROM ruby:2.5.3

RUN apt-get update && apt-get install -qq -y --no-install-recommends build-essential libpq-dev libsqlite3-dev curl imagemagick nodejs

RUN	groupadd -r -g 1000 docker && \
		useradd -r --create-home -u 1000 -g docker docker

WORKDIR /petalmd

COPY Gemfile /petalmd/Gemfile
COPY Gemfile.lock /petalmd/Gemfile.lock

RUN chown -R docker:docker /petalmd && \
chmod g+w /petalmd/Gemfile.lock

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

USER docker

RUN rm -rf node_modules vendor
RUN bundle install

COPY . /petalmd

CMD ["rails", "server", "-b", "0.0.0.0"]
