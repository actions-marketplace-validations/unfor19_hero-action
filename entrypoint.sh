#!/usr/bin/env bash
#shellcheck disable=SC2153
# Shellcheck ignores use of unknown environment variables

### Requirements
### ----------------------------------------
### curl
### ----------------------------------------


### Parsing command-line arguments
if [[ "$GITHUB_ACTION" = "true" || "$IS_DOCKER" = "true" ]]; then
    #shellcheck disable=SC1091
    source "/code/bargs.sh" "$@"
else
    #shellcheck disable=SC1090
    source "${PWD}/$(dirname "${BASH_SOURCE[0]}")/bargs.sh" "$@"
fi

set -e
set -o pipefail


### Functions
msg_error(){
    local msg="$1"
    echo -e "[ERROR] $(date) :: $msg"
    export DEBUG=1
    exit 1
}


msg_log(){
    local msg="$1"
    echo -e "[LOG] $(date) :: $msg"
}


has_substring() {
   # https://stackoverflow.com/a/38678184/5285732
   [[ "$1" != "${2/$1/}" ]]
}


validate_values(){
    declare -a values=()
    #shellcheck disable=SC2206
    values=($@)
    for item in "${values[@]}"; do
        if [[ "$item" = "null" ]]; then
            msg_error "Value not allowed, check inputs\n$(env | grep "HERO_.*=null")"
        fi
    done
}


github_create_status(){
    local gh_token
    local target_repository
    local target_workflow_name
    local src_repository
    local src_sha
    gh_token="$1"
    target_repository="$2"
    target_workflow_name="$3"
    src_repository="$4"
    src_sha="$5"

    local request_url
    local request_body
    request_url="https://api.github.com/repos/${target_repository}/statuses/${src_sha}"
    msg_log "Request URL - ${request_url}"
    request_body='{"state":"pending", "context": "test-action", "description": "Status of '"${target_repository}"'", "target_url": "https://github.com/'${target_repository}'/actions/workflows/'"${target_workflow_name}"'"}'
    msg_log "Request Body - ${request_body}"
    if curl --fail-with-body -sL -w "ResponseCode: %{http_code}\n" -X POST -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: Bearer ${gh_token}" \
        "$request_url" \
        -d "$request_body" ; then
        msg_log "Successfully dispatched"
    else
        msg_error "Failed to dispatch"
    fi
}


github_workflow_dispatch(){
    local gh_token
    local target_repository
    local target_workflow_name
    local target_ref
    local src_repository
    local src_workflow_name
    local src_sha
    gh_token="$1"
    target_repository="$2"
    target_workflow_name="$3"
    target_ref="$4"
    src_repository="$5"
    src_workflow_name="$6"
    src_sha="$7"

    local request_url
    local request_body
    request_url="https://api.github.com/repos/${target_repository}/actions/workflows/${target_workflow_name}/dispatches"
    msg_log "Request URL - ${request_url}"
    request_body='{"ref":"'"${target_ref}"'", "inputs": { "src_repository": "'"${src_repository}"'", "src_workflow_name": "'"${src_workflow_name}"'", "src_sha": "'"${src_sha}"'" } }'
    msg_log "Request Body - ${request_body}"
    if curl --fail-with-body -sL -w "ResponseCode: %{http_code}\n" -X POST -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: Bearer ${gh_token}" \
        "$request_url" \
        -d "$request_body" ; then
        msg_log "Successfully dispatched"
    else
        msg_error "Failed to dispatch"
    fi
}


### Global Variables
_HERO_ACTION="$HERO_ACTION"
_HERO_GH_TOKEN="$HERO_GH_TOKEN"
_HERO_TARGET_REPOSITORY="$HERO_TARGET_REPOSITORY"
_HERO_TARGET_WORKFLOW_NAME="$HERO_TARGET_WORKFLOW_NAME"
_HERO_TARGET_REF="$HERO_TARGET_REF"
_HERO_TARGET_JOB_STATUS="$HERO_TARGET_JOB_STATUS"
_HERO_SRC_REPOSITORY="$HERO_SRC_REPOSITORY"
_HERO_SRC_WORKFLOW_NAME="$HERO_SRC_WORKFLOW_NAME"
_HERO_SRC_SHA="$HERO_SRC_SHA"

### Main
if [[ "$_HERO_ACTION" =~ ^dispatch.* ]]; then
    validate_values "$_HERO_GH_TOKEN" "$_HERO_TARGET_REPOSITORY" "$_HERO_SRC_REPOSITORY" "$_HERO_SRC_SHA"
    github_workflow_dispatch \
        "$_HERO_GH_TOKEN" \
        "$_HERO_TARGET_REPOSITORY" \
        "$_HERO_TARGET_WORKFLOW_NAME" \
        "$_HERO_TARGET_REF" \
        "$_HERO_SRC_REPOSITORY" \
        "$_HERO_SRC_WORKFLOW_NAME" \
        "$_HERO_SRC_SHA"
    if [[ "$_HERO_ACTION" = "dispatch-status" ]]; then
        github_create_status \
            "$_HERO_GH_TOKEN" \
            "$_HERO_TARGET_REPOSITORY" \
            "$_HERO_TARGET_WORKFLOW_NAME" \
            "$_HERO_SRC_REPOSITORY" \
            "$_HERO_SRC_SHA"
    fi
else
    msg_error "Unknown HERO_ACTION - ${_HERO_ACTION}"
fi

msg_log "Completed successfully"
