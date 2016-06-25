#! /bin/bash
set -e

usage() {
    echo "usage: $0 [OPTIONS] \n" >&2
    echo "Script to run and build ascope for armhf, it defaults to build \n" >&2
    echo "OPTIONS:" >&2
    echo " -i, --install push click package on device" >&2
    echo >&2
    exit 1
}

build() {
    click-buddy --arch armhf --framework ubuntu-sdk-15.04 --dir .
}

install() {
    clicks=$(ls | grep \.click$ )
    for click in $clicks
    do
         adb push $click /tmp
             adb shell pkcon install-local --allow-untrusted /tmp/$click
    done
         
    adb shell restart unity8-dash
}

ARGS=`getopt -n$0 -u -a --longoptions="install" -o "sch" -- "$@"`
[ $? -ne 0 ] && usage
eval set -- "$ARGS"

[ $# -eq 1 ] && build

while [ $# -gt 1 ]
do
    case "$1" in
       -i|--install)   install;;
       -h|--help)      usage;;
       --)           shift;break;;
    esac
    shift
done

