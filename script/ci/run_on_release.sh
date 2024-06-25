#!/bin/sh

set -e

echo "Running migrations"
exit 1
bundle exec bin/rails db:migrate
