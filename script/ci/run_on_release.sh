#!/bin/sh

set -e

echo "Running migrations"
bundle exec bin/rails db:migrate
