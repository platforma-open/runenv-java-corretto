#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script settings
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"
cd "${script_dir}"

base_url="https://corretto.aws/downloads/resources"
version="21.0.2.13.1"

if [ "$#" -ne 2 ]; then
    echo ""
    echo "Usage: '${0}' <os> <arch>"
    echo "       '${0}' linux x64"
    echo ""
    echo "  OS list:"
    echo "    linux"
    echo "    windows"
    echo "    macosx"
    echo ""
    echo "  Arch list:"
    echo "    x64"
    echo "    aarch64"
    echo ""
    exit 1
fi

#
# Script parameters
#
os="${1}"
arch="${2}"
dst_root="${script_dir}/dld"
dst_data_dir="${dst_root}/corretto-${os}-${arch}"

function log() {
    printf "%s\n" "${*}"
}

function download() {
    local _ext="tar.gz"
    local _suffix=""
    if [ "${os}" == "windows" ]; then
        _suffix="-jdk"
        _ext="zip"
    fi

    local _url="${base_url}/${version}/amazon-corretto-${version}-${os}-${arch}${_suffix}.${_ext}"
    
    log "Downloading '${_url}'"
    wget --output-document="${dst_root}/corretto-${os}-${arch}.${_ext}" "${_url}"

}

function unpack() {
    case "${os}" in
        "linux")
            unpack_linux
            ;;
        "macosx")
            unpack_osx
            ;;
        "windows")
            unpack_windows
            ;;
    esac
}

function unpack_linux() {
    log "Unpacking archive for linux"
    
    rm -rf "${dst_data_dir}"
    mkdir "${dst_data_dir}"

    tar -x \
        -C "${dst_data_dir}" \
        --file "${dst_root}/corretto-${os}-${arch}.tar.gz" \
        --strip-components 1 \
        "amazon-corretto-${version}-${os}-${arch}"
}

function unpack_osx() {
    log "Unpacking archive for osx"
    
    rm -rf "${dst_data_dir}"
    mkdir "${dst_data_dir}"

    tar -x \
        -C "${dst_data_dir}" \
        --file "${dst_root}/corretto-${os}-${arch}.tar.gz" \
        --strip-components 3 \
        "amazon-corretto-21.jdk/Contents/Home/"
}

function unpack_windows() {
    log "Unpacking archive for windows"
    
    unzip \
        "${dst_root}/corretto-${os}-${arch}.zip" \
        "jdk21.0.2_13/*"

    rm -rf "${dst_data_dir}"
    mv jdk21.0.2_13/ "${dst_data_dir}"
}

mkdir -p "${dst_root}"
download
unpack
