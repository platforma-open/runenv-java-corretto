#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script state init
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"
repo_root="$(cd "${script_dir}/../" && pwd)"  # Get absolute path to repo root

if [ "$#" -ne 1 ]; then
    echo ""
    echo "Usage: '${0}' <version>"
    echo "       '${0}' 21.0.2.13.1"
    echo ""
    exit 1
fi

#
# Script parameters
#
version="${1}"
version_dir="${repo_root}/java-${version}"

# Change to version-specific directory
cd "${version_dir}"

#pl-pkg sign packages --all-platforms --sign-command='["gcloud-kms-sign", "{pkg}", "{pkg}.sig"]'
pl-pkg publish packages --all-platforms --fail-existing-packages