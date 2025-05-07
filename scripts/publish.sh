#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script state init
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"
cd "${script_dir}"

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

if ! [ -f "../dist/tengo/software/${version}.sw.json" ]; then
    echo ""
    echo "No software descriptor found at 'dist/tengo/software/${version}.sw.json'."
    echo ""
    echo "Looks like you're going to publish new version of amazon corretto java distribution."
    echo "See README.md for the instructions on how to do this properly."
    echo ""

    exit 1
fi

pl-pkg sign packages \
    --package-id="${version}" \
    --all-platforms \
    --sign-command='["gcloud-kms-sign", "{pkg}", "{pkg}.sig"]'

pl-pkg build descriptors --package-id="${version}-flags"
pl-pkg publish packages \
    --package-id="${version}" \
    --package-id="${version}-flags" \
    --fail-existing-packages \
    --all-platforms
