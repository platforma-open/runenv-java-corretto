#!/usr/bin/env bash

set -o errexit
set -o nounset

#
# Script state init
#
script_dir="$(cd "$(dirname "${0}")" && pwd)"
cd "${script_dir}"

base_url="https://corretto.aws/downloads/resources"

if [ "$#" -ne 3 ]; then
    echo ""
    echo "Usage: '${0}' <version> <os> <arch>"
    echo "       '${0}' 21.0.2.13.1 linux x64"
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
version="${1}"
os="${2}"
arch="${3}"
dst_root="$(cd "${script_dir}/../../"; pwd)/dld"
dst_data_dir="${dst_root}/corretto-${version}-${os}-${arch}"

dst_archive_ext="tar.gz"
if [ "${os}" == "windows" ]; then
    dst_archive_ext="zip"
fi
# Dirty change of the 'global' state from inside the function
dst_archive_path="${dst_root}/corretto-${version}-${os}-${arch}.${dst_archive_ext}"

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
    wget --quiet --output-document="${dst_archive_path}" "${_url}"
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
    log "Unpacking archive for linux to '${dst_data_dir}'"
    
    rm -rf "${dst_data_dir}"
    mkdir "${dst_data_dir}"

    tar -x \
        -C "${dst_data_dir}" \
        --file "${dst_archive_path}" \
        --strip-components 1 \
        "amazon-corretto-${version}-${os}-${arch}"
}

function unpack_osx() {
    log "Unpacking archive for osx to '${dst_data_dir}'"
    
    rm -rf "${dst_data_dir}"
    mkdir "${dst_data_dir}"

    tar -x \
        -C "${dst_data_dir}" \
        --file "${dst_archive_path}" \
        --strip-components 3 \
        "amazon-corretto-21.jdk/Contents/Home/"
}

function unpack_windows() {
    log "Unpacking archive for windows to '${dst_data_dir}'"

    local _dir_name="${version%.*}" # 21.0.4.7.1 -> 21.0.4.7
    _dir_name="${_dir_name%.*}_${_dir_name##*.}" # 21.0.4.7 -> 21.0.4_7
    _dir_name="jdk${_dir_name}" # 21.0.4_7 -> jdk21.0.4_7
    
    unzip \
        "${dst_archive_path}" \
        "${_dir_name}/*"

    rm -rf "${dst_data_dir}"
    mv "${_dir_name}/" "${dst_data_dir}"
}

mkdir -p "${dst_root}"
download
unpack
