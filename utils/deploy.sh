#!/bin/sh

#############################
# CONFIG

XVM_DIRS="res/icons res/data"
XVM_FILES="l10n/en.xc l10n/ru.xc"

#############################
# INTERNAL

err()
{
  echo "ERROR: $*"
  exit 1
}

check_config()
{
  [ "$WOT_PATH" != "" ] || err "WOT_PATH is not set in the build/xvm-build.conf"
  [ -d "$WOT_PATH" ] || err "WOT_PATH is invalid in the build/xvm-build.conf  WOT_PATH=$WOT_PATH"
  [ "$TARGET_VERSION" != "" ] || err "TARGET_VERSION is not set in the build/xvm-build.conf"
  [ -d "$WOT_PATH/res_mods/$TARGET_VERSION" ] || {
    err "TARGET_VERSION is invalid in the build/xvm-build.conf  TARGET_VERSION=$TARGET_VERSION"
  }
}

clear()
{
  rm -rf "$WOT_PATH/res_mods/mods/packages" || err "clear"
  rm -rf "$WOT_PATH/res_mods/mods/xfw" || err "clear"
  rm -f "$WOT_PATH/res_mods/$TARGET_VERSION/gui/flash/lobby.swf" || err "clear"
  rm -rf "$WOT_PATH/res_mods/$TARGET_VERSION/gui/scaleform" || err "clear"
  rm -rf "$WOT_PATH/res_mods/$TARGET_VERSION/scripts/client/gui/scaleform/locale" || err "clear"
}

make_dirs()
{
  mkdir -p "$WOT_PATH/res_mods/configs/xvm" || err "make_dirs"
  mkdir -p "$WOT_PATH/res_mods/mods" || err "make_dirs"
  mkdir -p "$WOT_PATH/res_mods/mods/shared_resources/xvm" || err "make_dirs"
  mkdir -p "$WOT_PATH/res_mods/$TARGET_VERSION" || err "make_dirs"
}

copy_xfw()
{
  echo "=> xfw"
  cp -a ../src/xfw/~output/swf_wg/* ../~output/~ver/gui/flash/
  cp -a ../src/xfw/~output/swf/* ../~output/mods/xfw/actionscript/
  cp -a ../src/xfw/~output/python/scripts/* ../~output/~ver/scripts/
  cp -a ../src/xfw/~output/python/mods/* ../~output/mods/
}

copy_output()
{
  echo "=> res_mods/$TARGET_VERSION"
  cp -a ../~output/~ver/* "$WOT_PATH/res_mods/$TARGET_VERSION" || err "copy_output"

  echo "=> res_mods/mods"
  cp -a ../~output/mods/* "$WOT_PATH/res_mods/mods" || err "copy_output"
}

copy_configs()
{
  echo "=> res_mods/configs/xvm"
  cp -a ../release/configs/* "$WOT_PATH/res_mods/configs/xvm" || err "copy_configs"

  echo "=> res_mods/configs/xvm/xvm.xc"
  if [ -f "test/configs/xvm.xc" ]; then
    cp -a "test/configs/xvm.xc" "$WOT_PATH/res_mods/configs/xvm/xvm.xc" || err "copy_configs"
  else
    rm -f "$WOT_PATH/res_mods/configs/xvm/xvm.xc" || err "copy_configs"
  fi
}

copy_xvm_audioww_dir()
{
  [ -d "../release/audioww" ] && {
    echo "=> audioww"
    mkdir -p "$TARGET_VERSION_PATH/audioww" || err "copy_xvm_audioww_dir"
    cp ../release/audioww/*.bnk "$TARGET_VERSION_PATH/audioww" || err "copy_xvm_audioww_dir"
  }
}

copy_xvm_dir()
{
  [ -e "$SHARED_RESOURCES_PATH/$1" ] && rm -rf "$SHARED_RESOURCES_PATH/$1"
  [ -d "../release/$1" ] && {
    echo "=> $1"
    mkdir -p $(dirname "$SHARED_RESOURCES_PATH/$1") || err "copy_xvm_dir"
    cp -a "../release/$1" "$SHARED_RESOURCES_PATH/$1" || err "copy_xvm_dir"
  }
}

copy_xvm_file()
{
  [ -f "$SHARED_RESOURCES_PATH/$1" ] && rm -f "$SHARED_RESOURCES_PATH/$1"
  [ -f "../release/$1" ] && {
    echo "=> $1"
    mkdir -p $(dirname "$SHARED_RESOURCES_PATH/$1") || err "copy_xvm_file"
    cp -a "../release/$1" "$SHARED_RESOURCES_PATH/$1" || err "copy_xvm_file"
  }
}

# MAIN

pushd $(dirname $(realpath $(cygpath --unix $0))) >/dev/null

# load config
. ../build/xvm-build.conf

TARGET_VERSION_PATH=$WOT_PATH/res_mods/$TARGET_VERSION
SHARED_RESOURCES_PATH=$WOT_PATH/res_mods/mods/shared_resources/xvm

# check config
check_config

# deploy
clear

make_dirs

copy_xfw

copy_output

copy_configs

copy_xvm_audioww_dir

for n in $XVM_DIRS; do
  copy_xvm_dir $n
done

for n in $XVM_FILES; do
  copy_xvm_file $n
done

popd >/dev/null
