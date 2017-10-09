#!/bin/bash
if ! [ -x "$(command -v brew)" ]; then
  echo 'installing homebrew...' >&2
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! [ -x "$(command -v bundle)" ]; then
  echo 'installing bundler...' >&2
  gem install bundler
fi

if ! [ -x "$(command -v foreman)" ]; then
  echo 'installing foreman gem...' >&2
  gem install foreman
fi

if [ ! -f tmp/output.txt ]; then
  echo 'initializing output file...' >&2
  touch tmp/output.txt
fi


brew tap homebrew/bundle
brew bundle

echo 'starting redis deamon...' >&2
redis-server /usr/local/etc/redis.conf --daemonize yes

(
  cd crystal-app
  if [ ! -d lib ]; then
    echo 'installing crystal_app dependencies...' >&2
    shards install
  fi
  if [ ! -f bin/sidekiq ]; then
    echo 'compiling crystal_app sidekiq...' >&2
    crystal build --release src/sidekiq.cr -o bin/sidekiq
  fi
  if [ ! -f bin/sidekiq_web ]; then
    echo 'compiling crystal_app sidekiq web interface...' >&2
    crystal build --release src/sidekiq_web.cr -o bin/sidekiq_web
  fi
)

(
  cd ruby-app
  if [ ! -d vendor/bundle/ruby ]; then
    echo 'installing ruby_app dependencies...' >&2
    bundle install --path=vendor/bundle
  fi
)

foreman start
