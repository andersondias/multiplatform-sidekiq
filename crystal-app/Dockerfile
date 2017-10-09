FROM crystallang/crystal:0.23.1

ADD shard.yml /app/
ADD shard.lock /app/
WORKDIR /app
RUN shards install

# Add app and build it
ADD . /app

RUN crystal build --release --no-debug src/sidekiq.cr -o bin/sidekiq
RUN crystal build --release --no-debug src/sidekiq_web.cr -o bin/sidekiq_web
