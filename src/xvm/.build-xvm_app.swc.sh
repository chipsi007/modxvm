#!/bin/bash

# XVM team (c) https://modxvm.com 2014-2018
# XVM build system

currentdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$currentdir"/../../src/xfw/build/library.sh

detect_os
detect_flex

#xfw.swc
frswc="$FLEX_HOME/frameworks/libs/framework.swc"
class="com.xvm.XvmAppBase"
"$XVMBUILD_COMPC_FILEPATH" \
    -framework="$FLEX_HOME/frameworks" \
    -source-path xvm_app \
    -external-library-path+="$frswc" \
    -external-library-path+=../xfw/~output/swc/wg_shared.swc \
    -external-library-path+=../xfw/~output/swc/xfw.swc \
    -external-library-path+=../../~output/swc/xvm_shared.swc \
    -output ../../~output/swc/xvm_app.swc \
    -include-classes $class
