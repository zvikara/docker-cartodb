#!/bin/bash

PORT=3000

chown -R postgres:postgres /var/lib/postgresql/9.3/main
chmod 700 /var/lib/postgresql/9.3/main

service postgresql start
service redis-server start
service varnish start

cd /Windshaft-cartodb
node app.js development &

cd /CartoDB-SQL-API
node app.js development &

cd /cartodb
source /usr/local/rvm/scripts/rvm
#bundle exec rake cartodb:db:setup
bundle exec script/restore_redis
bundle exec script/resque > resque.log 2>&1 &
bundle exec rails s -p $PORT
