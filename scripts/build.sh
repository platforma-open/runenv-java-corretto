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
main_version="${version%%.*}"  # Extract main version (e.g., 21 from 21.0.2.13.1)

# Create version-specific directory if it doesn't exist
mkdir -p "${version_dir}"
cd "${version_dir}"

pl-pkg build descriptors

"${script_dir}/${main_version}.x/pkg-download.sh" "${version}" macosx x64
"${script_dir}/${main_version}.x/pkg-download.sh" "${version}" macosx aarch64
"${script_dir}/${main_version}.x/pkg-download.sh" "${version}" linux x64
"${script_dir}/${main_version}.x/pkg-download.sh" "${version}" linux aarch64
"${script_dir}/${main_version}.x/pkg-download.sh" "${version}" windows x64

pl-pkg build packages --all-platforms
