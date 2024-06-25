#!/bin/bash

set -e

echo "Running migrations"
bundle exec bin/rails db:migrate

# to test concurrent releases in the stack
if [ "$HONEYBADGER_ENV" == "stack" ]; then
  for i in {1..120}; do
    echo "Waiting for 10 minutes, $i/120"
    sleep 5
  done
fi
