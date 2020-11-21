web: yarn --cwd front run start & bundle exec puma -C config/puma.rb -p 3000 && fg
rpush: bundle exec rpush start -e $RAILS_ENV -f
release: rake db:migrate