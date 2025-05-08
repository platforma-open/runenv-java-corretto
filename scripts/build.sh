#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script state init
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"

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

pl-pkg build descriptors

"${script_dir}/download.sh" "${version}" macosx x64
"${script_dir}/download.sh" "${version}" macosx aarch64
"${script_dir}/download.sh" "${version}" linux x64
"${script_dir}/download.sh" "${version}" linux aarch64
"${script_dir}/download.sh" "${version}" windows x64

pl-pkg build packages --all-platforms
