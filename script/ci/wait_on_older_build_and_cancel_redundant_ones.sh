#!/bin/bash

set -e
set -o pipefail
shopt -s inherit_errexit  # Command substitution inherits "set -e".

pending_lifecycle='"queued","scheduled","not_run","not_running"'
base_url="https://circleci.com/api/v1.1/project/github/${CIRCLE_PROJECT_USERNAME:?}/${CIRCLE_PROJECT_REPONAME:?}"
builds_for_the_same_job_on_the_same_branch=". | map(select(.workflows.job_name == \"${CIRCLE_JOB:?}\" and .branch == \"${CIRCLE_BRANCH:?}\"))"

_main () {
  latest_build_num=$(_latest_build_num)
  if [[ "${CIRCLE_BUILD_NUM:?}" = "${latest_build_num}" ]]; then
    build_date=$(date)
    echo "Current build is the latest build at ${build_date}"

    _wait_for_older_builds_to_finish
    exit 0
  fi

  # Don't cancel the current build until we've had the time to cancel others.
  _cancel_all_build_except_latest_and_current

  echo "Canceling ourselves since we're not the latest build"
  _cancel_build "${CIRCLE_BUILD_NUM}"

  # Give the cancellation request time to process. Otherwise this script would exit and make the job succeed/fail before it can be canceled.
  sleep 10

  # If the request failed, fail the build. Otherwise we might continue e.g. to deploy when we shouldn't.
  exit 1
}

_cancel_build () {
  build_num=$1

  if curl --silent --user "${CIRCLE_API_TOKEN:?}:" -X POST "${base_url}/${build_num}/cancel" > /dev/null; then
    echo "Canceling build ${build_num}: Success"
  else
    echo "Canceling build ${build_num}: Failed"
  fi
}

_cancel_all_build_except_latest_and_current () {
  for build_num in $(_latest_builds_in_current_project_json | jq "${builds_for_the_same_job_on_the_same_branch} | map(select(.lifecycle == (${pending_lifecycle}))) | [.[].build_num] | sort | .[0:-1] | .[]"); do
    if [[ "${build_num}" = "${CIRCLE_BUILD_NUM}" ]]; then
      continue
    fi

    _cancel_build "${build_num}" &
  done
  wait
}

_latest_build_num () { _latest_builds_in_current_project_json | jq "${builds_for_the_same_job_on_the_same_branch} | [.[].build_num] | max"; }
_latest_builds_in_current_project_json () { curl --silent --user "${CIRCLE_API_TOKEN:?}:" "${base_url}"; }

_wait_for_older_builds_to_finish () {
  printf 'Waiting for older builds to finish...'

  while true; do
    older_running_builds=$(_latest_builds_in_current_project_json | jq "${builds_for_the_same_job_on_the_same_branch} | map(select(.lifecycle == \"running\")) | map(select(.build_num < ${CIRCLE_BUILD_NUM})) | [ .[].build_num ]")
    if [[ "${older_running_builds}" = "[]" ]]; then
      echo " Done"
      break
    fi

    printf '.'
    sleep 1
  done
}

_main
