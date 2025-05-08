#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script state init
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"

#pl-pkg sign packages --all-platforms --sign-command='["gcloud-kms-sign", "{pkg}", "{pkg}.sig"]'
pl-pkg publish packages --all-platforms --fail-existing-packages
