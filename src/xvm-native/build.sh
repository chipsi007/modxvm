#!/bin/bash

# XVM Native ping module

currentdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$currentdir"/../../build/library.sh

copy()
{
    mkdir -p "$currentdir/../../~output/mods/packages/"
    cp -rf "$currentdir/release/packages/" "$currentdir/../../~output/mods/"

    mkdir -p "$currentdir/../../~output/mods/xfw/"
    cp -rf "$currentdir/release/xfw/" "$currentdir/../../~output/mods/"
    cp -rf "$currentdir/libpython/release/libpython/bin/python27.dll" "$currentdir/../../~output/mods/xfw/native/python27.dll"
}

copy