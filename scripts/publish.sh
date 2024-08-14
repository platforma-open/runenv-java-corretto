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

./21.x/pkg-build.sh "${version}" linux x64
./21.x/pkg-publish.sh "${version}" linux x64

./21.x/pkg-build.sh "${version}" linux aarch64
./21.x/pkg-publish.sh "${version}" linux aarch64

./21.x/pkg-build.sh "${version}" windows x64
./21.x/pkg-publish.sh "${version}" windows x64

./21.x/pkg-build.sh "${version}" macosx x64
./21.x/pkg-publish.sh "${version}" macosx x64

./21.x/pkg-build.sh "${version}" macosx aarch64
./21.x/pkg-publish.sh "${version}" macosx aarch64
