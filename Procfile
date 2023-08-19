web: ./bin/hivemind Procfile_prod
rpush: bundle exec rpush start -e $RAILS_ENV -f
worker: bundle exec sidekiq
release: rake db:migrate
