#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VERSION_RELEASE="$(cat ${SCRIPT_PATH}/../VERSION)"
PROJECT_ID="${CI_PROJECT_ID:-}"

function validate {
    echo "Checking the availability of the tag ..."
    if [[ -z "$(git tag -l | grep -w ${VERSION_RELEASE})" ]]; then
        echo "The ${VERSION_RELEASE} tag is available to use.";
    else
        echo "The ${VERSION_RELEASE} tag has already been used.";
        echo "We stop the next jobs."
        exit 1;
    fi
}

function release {
    echo "Creating the tag for the project ..."
    curl --silent --request POST \
         --header "PRIVATE-TOKEN: ${API_TOKEN}" \
         "${GITLAB_URL}/api/v4/projects/${PROJECT_ID}/repository/tags?tag_name=${VERSION_RELEASE}&ref=master" | jq
    echo "Done."
}

$1