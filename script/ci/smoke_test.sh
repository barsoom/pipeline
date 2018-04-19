#!/bin/sh
curl -s "$APP_URL" | grep Pipeline 1> /dev/null || exit 1
