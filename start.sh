#!/bin/sh

echo "Migrating database."
bundle exec rake db:migrate
echo "Done migrating database. Starting Server"
bundle exec puma -p 3000 --quiet --threads 8:32
