crystal: cd crystal-app; ./bin/sidekiq -q crystal
web: cd crystal-app; ./bin/sidekiq_web
ruby: cd ruby-app; bundle exec sidekiq -r ./app/ruby_app.rb -q ruby
tail: tail -f tmp/output.txt
