#!/usr/bin/env bash

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


### Global Variables


### Main
msg_log "Completed successfully"
