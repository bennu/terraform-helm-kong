#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
set +x
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VERSION_RELEASE="$(cat ${SCRIPT_PATH}/../release/version)"
PROJECT_ID="${CI_PROJECT_ID:-}"

function validate {
    if [[ -z $(git tag -l | grep -w ${VERSION_RELEASE}) ]];then
        echo "Tag ${VERSION_RELEASE} está disponible para usarlo";
    else
        "El tag ${VERSION_RELEASE} ya fue creado";
        exit 1;
    fi
}

function release {
    curl --silent --request POST \
         --header "PRIVATE-TOKEN: ${API_TOKEN}" \
         "${GITLAB_URL}/api/v4/projects/${PROJECT_ID}/repository/tags?tag_name=${VERSION_RELEASE}&ref=master" | jq
}

$1