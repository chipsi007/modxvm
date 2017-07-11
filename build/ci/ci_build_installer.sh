#!/bin/bash

# XVM team (c) www.modxvm.com 2014-2017
# XVM nightly build system

CURRENT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$CURRENT_PATH"
export XVMBUILD_REPOSITORY_PATH="$CURRENT_PATH/../.."

source /var/xvm/ci_config.sh

"$XVMBUILD_REPOSITORY_PATH/src/installer/build.sh"
