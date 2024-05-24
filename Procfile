web: bundle exec puma -C config/puma.rb -p 50000
rpush: bundle exec rpush start -e $RAILS_ENV -f
worker: bundle exec sidekiq
release: rake db:migrate
