#!/bin/bash

set -e

app_name=$1
revision=$2
heroku_token=$HEROKU_REGISTRY_TOKEN

# Deploy
_main () {
  _deploy_to_heroku
  _ensure_new_revision_is_running
}

_deploy_to_heroku () {
  curl -X PATCH "https://api.heroku.com/apps/$app_name/formation" \
    --no-progress-meter \
    -H "Content-Type: application/json" \
    -H "Accept: application/vnd.heroku+json; version=3.docker-releases" \
    -H "Authorization: Bearer $heroku_token" \
    -d "$(_heroku_release_json)"
}

_ensure_new_revision_is_running () { timeout 10m script/ci/wait_for_new_revision_to_serve_requests.sh "$app_name" "$revision"; }

_heroku_release_json () {
  docker_image=$(curl -s -X GET "https://_:$heroku_token@registry.heroku.com/v2/$app_name/app/manifests/$revision" --header "Accept: application/vnd.docker.distribution.manifest.v2+json" | jq -r ".config.digest")

  if ! [[ "$docker_image" =~ sha256:[A-Fa-f0-9]{64} ]]; then
    echo "Unexpected format for docker image: $docker_image"
  fi

  heroku_release_json='{ "updates": [] }'

  while read -r line; do
    type=$(echo "$line" | cut -f1 -d:)
    command=$(echo "$line" | cut -f2 -d:)

    update_json=$(jq -n \
      --arg type "$type" \
      --arg docker_image "$docker_image" \
      --arg command "$command" \
      '[ { type: $type, docker_image: $docker_image, command: $command } ]')

    heroku_release_json=$(echo "$heroku_release_json" | jq ".updates += $update_json")
  done < Procfile

  # Die if we don't see web mentioned, as a confidence check
  echo "$heroku_release_json" | grep --silent "web"

  echo "$heroku_release_json"
}

_main
