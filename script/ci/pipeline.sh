#!/bin/bash

set -e

# Script to report build status to pipeline (a dashboard for CI status)
# See more at: https://github.com/barsoom/pipeline

build_name=$1
command_to_run=$2

# Shortcut to just run the build command if pipeline is not configured
if [[ ! -v "PIPELINE_API_TOKEN" ]]; then
  $command_to_run || exit 1
  exit 0
fi

# Don't report non-default branch builds
if [ "${CIRCLE_BRANCH}" != "master" ]; then
  $command_to_run || exit 1
  exit 0
fi

_main () {
  # Report start of build
  _post_build_status "building"

  # Report if the build succeeded of failed
  if $command_to_run; then
    _post_build_status "successful"
  else
    _post_build_status "failed"
    exit 1
  fi
}

_post_build_status () {
  local status_url="https://circleci.com/gh/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/${CIRCLE_BUILD_NUM}&status=$1"
  local repository="git@github.com:${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}.git"
  local revision="${CIRCLE_SHA1}"

  curl --no-progress-meter \
    --request POST \
    "$PIPELINE_BASE_URL/api/build_status" \
    --data "token=$PIPELINE_API_TOKEN&name=${build_name}&repository=${repository}&revision=${revision}&status_url=${status_url}"
}

_main
