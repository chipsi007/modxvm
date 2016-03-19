#!/bin/bash

# XVM team (c) www.modxvm.com 2014-2015
# XVM nightly build system

XVMBUILD_ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$XVMBUILD_ROOT_PATH"

source ./build/library.sh
source ./build/xvm-build.conf

##########################
####      CONFIG      ####
##########################
# $XVMBUILD_MONO_FILENAME
# $XVMBUILD_FDBUILD_FILEPATH

# $XVMBUILD_OUTPUT_PATH
if [[ "$XVMBUILD_OUTPUT_PATH" == "" ]]; then
    export XVMBUILD_OUTPUT_PATH="output"
fi

# $XVMBUILD_REPOSITORY_PATH
if [[ "$XVMBUILD_REPOSITORY_PATH" == "" ]]; then
    export XVMBUILD_REPOSITORY_PATH="."
fi

# $XVMBUILD_L10N_URL
if [[ "$XVMBUILD_L10N_URL" == "" ]]; then
    export XVMBUILD_L10N_URL="http://translate.by-reservation.com/download/xvm-client/xvm_l10n_json.zip"
fi

XVMBUILD_XVM_URL="http://nightly.modxvm.com/download"

##########################
#### HELPER FUNCTIONS ####
##########################
clean_repodir(){
    pushd "$XVMBUILD_REPOSITORY_PATH" > /dev/null

    rm -rf src/xvm/lib/*
    rm -rf src/xvm/obj/
    rm -rf src/xfw/src/actionscript/lib/*
    rm -rf src/xfw/src/actionscript/obj/*
    rm -rf src/xfw/src/actionscript/output/*
    rm -rf src/xvm-as2/include/
    rm -rf src/xvm-as2/swf/battle.swf
    rm -rf src/xvm-as2/swf/PlayersPanel.swf
    rm -rf src/xvm-as2/swf/StatisticForm.swf
    rm -rf src/xvm-as2/swf/TeamBasesPanel.swf
    rm -rf src/xvm-as2/swf/VehicleMarkersManager.swf
    rm -rf src/xvm-as2/swf/temp/
    rm -rf ~output/
    rm -rf src/xfw/~output/

    popd > /dev/null
}

clean_outputdir(){
    rm -rf "$XVMBUILD_OUTPUT_PATH"/
}

clean_sha1()
{
    pushd "$XVMBUILD_REPOSITORY_PATH" > /dev/null
    rm -rf ~output/sha1/
    rm -rf src/xfw/~output/sha1/
    popd > /dev/null 
}

create_directories(){
    pushd "$XVMBUILD_REPOSITORY_PATH" > /dev/null
    mkdir -p ~output/~ver/gui/flash
    mkdir -p ~output/~ver/gui/scaleform
    mkdir -p ~output/~ver/scripts
    mkdir -p ~output/configs/xvm
    mkdir -p ~output/mods/xfw/actionscript
    mkdir -p ~output/mods/xfw/python
    mkdir -p ~output/mods/shared_resources/xvm/
    mkdir -p src/xvm-as2/swf/temp/
    popd > /dev/null
}

extend_path(){
    export PATH=$PATH:"$XVMBUILD_ROOT_PATH"/build/bin/java/:"$XVMBUILD_ROOT_PATH"/build/bin/msil/:"$XVMBUILD_ROOT_PATH"/build/bin/"$OS"_"$arch"/
}

load_repositorystats(){
    #read xvm revision and hash
    pushd "$XVMBUILD_REPOSITORY_PATH"/ > /dev/null       
        export XVMBUILD_XVM_BRANCH=$(hg parent --template "{branch}") || exit 1
        export XVMBUILD_XVM_HASH=$(hg parent --template "{node|short}") || exit 1
        export XVMBUILD_XVM_REVISION=$(hg parent --template "{rev}") || exit 1
        export XVMBUILD_XVM_COMMITMSG=$(hg parent --template "{desc}") || exit 1
        export XVMBUILD_XVM_COMMITAUTHOR=$(hg parent --template "{author}" | sed 's/<.*//') || exit 1
    popd > /dev/null

    #read xfw revision and hash
    pushd "$XVMBUILD_REPOSITORY_PATH"/src/xfw/ > /dev/null
        export XVMBUILD_XFW_BRANCH=$(hg parent --template "{branch}") || exit 1
        export XVMBUILD_XFW_HASH=$(hg parent --template "{node|short}") || exit 1
        export XVMBUILD_XFW_REVISION=$(hg parent --template "{rev}") || exit 1
    popd > /dev/null
}

load_version(){
    export XVMBUILD_WOT_VERSION="$TARGET_VERSION"
    export XVMBUILD_XVM_VERSION="$XVM_VERSION"
}

##########################
####  BUILD FUNCTIONS ####
##########################

patch_as2(){
    pushd "$XVMBUILD_REPOSITORY_PATH"/src/xvm-as2/swf/ > /dev/null
    ./make-patched-swfs.sh    
    ./make-patched-swfs-ffdec.sh    
    popd > /dev/null
}

build_as2(){
    echo ""
    echo "Building AS2 files"

    pushd "$XVMBUILD_REPOSITORY_PATH"/src/xvm-as2/ > /dev/null
    for proj in *.as2proj;
        do
            echo "Building $proj"
            build_as2_h "$proj"
        done
    popd > /dev/null
}

build_as3(){
    echo ""
    echo "Building AS3 files"

    pushd "$XVMBUILD_REPOSITORY_PATH"/src/xvm/ > /dev/null

    for proj in _*.as3proj;
        do
            echo "Building $proj"
            build_as3_h "$proj"
        done
    for proj in xvm_*.as3proj;
        do
            echo "Building $proj"
            build_as3_h "$proj"
        done

    popd > /dev/null
}

build_xpm(){
    echo ""
    echo "Building XPM"

    pushd "$XVMBUILD_REPOSITORY_PATH"/src/xpm/ >/dev/null
    ./build-all.sh
    popd >/dev/null
}

build_xfw(){
    echo ""
    echo "Building XFW"

    pushd "$XVMBUILD_REPOSITORY_PATH"/src/xfw/ >/dev/null
    ./build.sh
    popd >/dev/null

    pushd "$XVMBUILD_REPOSITORY_PATH" >/dev/null
    cp -rf src/xfw/~output/swf_wg/*.swf ~output/~ver/gui/flash/
    cp -rf src/xfw/~output/python/mods/* ~output/mods/
    cp -rf src/xfw/~output/python/scripts/* ~output/~ver/scripts/
    cp -rf src/xfw/~output/swf/*.swf ~output/mods/xfw/actionscript/
    popd >/dev/null
}

calc_hash_for_xvm_integrity(){
    echo ""
    echo "Calculating hashes for xvm_integrity"
    
    pushd ~output > /dev/null
    hash_file='res_mods/mods/packages/xvm_integrity/python/hash_table.py'
    echo -e '""" Generated automatically by XVM builder """\nHASH_DATA = {' > $hash_file
    find res_mods -name *.pyc -print0 -o -name *.swf -print0 | while read -d $'\0' file
    do
        sha1sum "$file" | sed -r "s/(\S+)\s+\*?(.+)/'\2': '\1',/" >> $hash_file
    done
    echo "}" >> $hash_file
    "$XVMBUILD_PYTHON_FILEPATH" -c "import py_compile; py_compile.compile('$hash_file')"
    rm $hash_file
    popd >/dev/null
}

copy_files(){
    # rename version-dependent folder
    mv "$XVMBUILD_REPOSITORY_PATH"/~output/~ver/ "$XVMBUILD_REPOSITORY_PATH"/~output/"$XVMBUILD_WOT_VERSION"

    # cp non-binary files
    mkdir -p "$XVMBUILD_REPOSITORY_PATH"/~output/"$XVMBUILD_WOT_VERSION"/audioww/
    cp -f "$XVMBUILD_REPOSITORY_PATH"/release/audioww/*.bnk "$XVMBUILD_REPOSITORY_PATH"/~output/"$XVMBUILD_WOT_VERSION"/audioww/
    cp -rf "$XVMBUILD_REPOSITORY_PATH"/release/* "$XVMBUILD_REPOSITORY_PATH"/~output/mods/shared_resources/xvm/
    mv "$XVMBUILD_REPOSITORY_PATH"/~output/mods/shared_resources/xvm/configs/* "$XVMBUILD_REPOSITORY_PATH"/~output/configs/xvm
    rm -rf "$XVMBUILD_REPOSITORY_PATH"/~output/mods/shared_resources/xvm/configs/

    # get l10n files from translation server
    pushd "$XVMBUILD_REPOSITORY_PATH"/~output/mods/shared_resources/xvm/l10n/ >/dev/null
    mkdir -p temp
    cd temp
    wget --quiet --output-document=l10n.zip "$XVMBUILD_L10N_URL"
    unzip -o l10n.zip >/dev/null
    rm l10n.zip ru.xc
    cd ..
    mv temp/* ./
    rm -rf temp/
    popd >/dev/null

    # move all in res_mods
    
    pushd "$XVMBUILD_REPOSITORY_PATH"/ > /dev/null
    mkdir -p res_mods/
    mv ~output/* res_mods/
    mv res_mods ~output/
    popd >/dev/null

    # put readmes on root
    pushd "$XVMBUILD_REPOSITORY_PATH"/~output/res_mods/mods/shared_resources/xvm/doc/ > /dev/null
    find . -name "readme-*.txt" -exec cp {} ../../../../../ \;
    popd > /dev/null

    # remove swc
    rm -r "$XVMBUILD_REPOSITORY_PATH"/~output/res_mods/swc/

}

pack_xfw(){
    echo ""
    echo "Packing XFW"

    echo "$XVMBUILD_XFW_REVISION" >> "$XVMBUILD_REPOSITORY_PATH"/src/xfw/~output/"$XVMBUILD_XFW_REVISION"
    echo "$XVMBUILD_XFW_HASH" >> "$XVMBUILD_REPOSITORY_PATH"/src/xfw/~output/"$XVMBUILD_XFW_REVISION"
    echo "$XVMBUILD_XFW_BRANCH" >> "$XVMBUILD_REPOSITORY_PATH"/src/xfw/~output/"$XVMBUILD_XFW_REVISION"
    
    pushd "$XVMBUILD_REPOSITORY_PATH"/src/xfw/~output/ > /dev/null 
    zip -9 -r -q "$XVMBUILD_XFW_REVISION"_"$XVMBUILD_XFW_HASH"_xfw.zip ./
    rm "$XVMBUILD_XFW_REVISION"
    popd > /dev/null
}

pack_xvm(){
    echo ""
    echo "Packing build"

    echo "$XVMBUILD_XVM_REVISION" >> "$XVMBUILD_REPOSITORY_PATH"/~output/"$XVMBUILD_XVM_REVISION"
    echo "$XVMBUILD_XVM_HASH" >> "$XVMBUILD_REPOSITORY_PATH"/~output/"$XVMBUILD_XVM_REVISION"
    echo "$XVMBUILD_XVM_BRANCH" >> "$XVMBUILD_REPOSITORY_PATH"/~output/"$XVMBUILD_XVM_REVISION"

    pushd "$XVMBUILD_REPOSITORY_PATH"/~output/ > /dev/null 
    zip -9 -r -q "$XVMBUILD_XVM_REVISION"_"$XVMBUILD_XVM_HASH"_xvm.zip ./
    popd > /dev/null   
}

deploy_xvm(){
    echo ""
    echo "Deploying build"

    XVMBUILD_OUTPUT_PATH="$XVMBUILD_OUTPUT_PATH"/"$XVMBUILD_XVM_BRANCH"
    mkdir -p "$XVMBUILD_OUTPUT_PATH"/

    mv -f "$XVMBUILD_REPOSITORY_PATH"/src/xfw/~output/"$XVMBUILD_XFW_REVISION"_"$XVMBUILD_XFW_HASH"_xfw.zip "$XVMBUILD_OUTPUT_PATH"/
    mv -f "$XVMBUILD_REPOSITORY_PATH"/~output/"$XVMBUILD_XVM_REVISION"_"$XVMBUILD_XVM_HASH"_xvm.zip "$XVMBUILD_OUTPUT_PATH"/

    cp -f "$XVMBUILD_OUTPUT_PATH"/"$XVMBUILD_XVM_REVISION"_"$XVMBUILD_XVM_HASH"_xvm.zip "$XVMBUILD_OUTPUT_PATH"/latest_xvm.zip
    cp -f "$XVMBUILD_OUTPUT_PATH"/"$XVMBUILD_XFW_REVISION"_"$XVMBUILD_XFW_HASH"_xfw.zip "$XVMBUILD_OUTPUT_PATH"/latest_xfw.zip

    echo $XVMBUILD_XVM_REVISION > "$XVMBUILD_OUTPUT_PATH"/xvm_revision.txt
    echo $XVMBUILD_XVM_HASH > "$XVMBUILD_OUTPUT_PATH"/xvm_hash.txt
    echo $XVMBUILD_XVM_BRANCH > "$XVMBUILD_OUTPUT_PATH"/xvm_branch.txt
    echo $XVMBUILD_XVM_VERSION > "$XVMBUILD_OUTPUT_PATH"/xvm_version.txt
    echo $XVMBUILD_XFW_REVISION > "$XVMBUILD_OUTPUT_PATH"/xfw_revision.txt
    echo $XVMBUILD_XFW_HASH > "$XVMBUILD_OUTPUT_PATH"/xfw_hash.txt
    echo $XVMBUILD_XFW_BRANCH > "$XVMBUILD_OUTPUT_PATH"/xfw_branch.txt
    echo $XVMBUILD_WOT_VERSION > "$XVMBUILD_OUTPUT_PATH"/wot_version.txt
}

post_ipb(){
#!/bin/bash

if [ "$XVMBUILD_IPB_APIKEY" == "" ]; then
  return 0
fi

downloadlinkzip="$XVMBUILD_XVM_URL"/"$XVMBUILD_XVM_BRANCH"/"$XVMBUILD_XVM_REVISION"_"$XVMBUILD_XVM_HASH"_xvm.zip
downloadlinkexe="$XVMBUILD_XVM_URL"/"$XVMBUILD_XVM_BRANCH"/"$XVMBUILD_XVM_REVISION"_"$XVMBUILD_XVM_BRANCH"_xvm.exe

XVMBUILD_IPB_TEXT=$(printf "[b]Build:[/b] [url=https://bitbucket.org/XVM/xvm/commits/$XVMBUILD_XVM_HASH]$XVMBUILD_XVM_REVISION (branch $XVMBUILD_XVM_BRANCH)[/url] \n [b]Download:[/b] [url=$downloadlinkzip].zip archive[/url] | [url=$downloadlinkexe].exe installer[/url]  \n [b]Author:[/b] $XVMBUILD_XVM_COMMITAUTHOR \n [b]Description:[/b] $XVMBUILD_XVM_COMMITMSG [hr]")

XVMBUILD_IPB_REQURL="http://www.koreanrandom.com/forum/interface/board/index.php"
XVMBUILD_IPB_REQBODY="<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<methodCall>
  <methodName>postReply</methodName>
  <params>
    <param>
      <value>
        <struct>
          <member>
            <name>api_module</name>
            <value><string>ipb</string></value>
          </member>
          <member>
            <name>api_key</name>
            <value><string>$XVMBUILD_IPB_APIKEY</string></value>
          </member>
          <member>
            <name>member_field</name>
            <value><string>member_id</string></value></member>
          <member>
            <name>member_key</name>
            <value><string>$XVMBUILD_IPB_USERID</string></value>
          </member>
          <member>
            <name>topic_id</name>
            <value><string>$XVMBUILD_IPB_TOPICID</string></value>
          </member>
          <member>
            <name>post_content</name>
            <value><string>$XVMBUILD_IPB_TEXT</string></value>
          </member>
        </struct>
      </value>
    </param>
  </params>
</methodCall>"

echo $XVMBUILD_IPB_REQTEXT
echo $XVMBUILD_IPB_REQBODY

curl -sS -H "Content-Type: text/xml" -H "User-Agent: IPS XML-RPC Client Library (\$Revision: 10721 $)\r\n" -X POST --data "$XVMBUILD_IPB_REQBODY" "$XVMBUILD_IPB_REQURL"

}

##########################
####  BUILD PIPELINE  ####
##########################
pushd "$XVMBUILD_ROOT_PATH" >/dev/null

detect_os
detect_arch

extend_path

detect_mono
detect_java
detect_ffdec
detect_fdbuild
detect_flex
detect_mtasc
detect_swfmill
detect_wget
detect_zip
detect_python

load_repositorystats
load_version

clean_repodir
clean_outputdir
create_directories

patch_as2
build_as2
build_xpm
build_xfw
build_as3

clean_sha1
copy_files
calc_hash_for_xvm_integrity
pack_xvm
pack_xfw

deploy_xvm

clean_repodir

post_ipb

popd >/dev/null
