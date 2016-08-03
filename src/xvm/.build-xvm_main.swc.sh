#!/bin/bash

# XVM team (c) www.modxvm.com 2014-2016
# XVM build system

currentdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$currentdir"/../../build/library.sh

detect_os
detect_flex

#xfw.swc
frswc="$FLEX_HOME/frameworks/libs/framework.swc"
class="com.xvm.XvmMain"
"$XVMBUILD_COMPC_FILEPATH" \
    -framework="$FLEX_HOME/frameworks" \
    -source-path xvm_main \
    -external-library-path+="$frswc" \
    -external-library-path+=../xfw/~output/swc/wg_lobby.swc \
    -external-library-path+=../xfw/~output/swc/xfw_shared.swc \
    -external-library-path+=../xfw/~output/swc/xfw.swc \
    -library-path+=../../~output/swc/xvm_shared.swc \
    -output ../../~output/swc/xvm_main.swc \
    -include-classes $class
