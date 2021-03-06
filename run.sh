#!/bin/sh

repo="https://git.openwrt.org/openwrt/openwrt.git"
git="$HOME/git"
branch="openwrt-22.03"
tag="v22.03.0-rc5"

if [ ! -d ~/openwrt/bin ]; then
    git clone $repo -b $branch
    cd openwrt || exit 1
    git checkout  $tag
    sed -i '/ telephony /s/^/#/' ./feeds.conf.default
    git clone  'https://github.com/chenhw2/openwrt-v2ray-plugin.git' ./package/v2ray-plugin
    git clone 'https://github.com/ALSe61/openwrt-r3p-mtk.git'
    #git clone 'https://github.com/Azexios/openwrt-r3p-mtk.git'
    mkdir files
    
else
    cd openwrt
fi

./scripts/feeds update -a && \
./scripts/feeds install -a

cp -f $git/.config .
rsync -av --delete  $git/files/ $HOME/openwrt/files
rsync -av  openwrt-r3p-mtk/ . --exclude '.git'

make defconfig
make clean
make menuconfig
make world -j5 || make -j5 V=s

if [ $? = 0 ]; then
    ./scripts/diffconfig.sh > diffconfig
    [ "$(cmp diffconfig $git/.config)" = true ] || cat diffconfig > $git/.config
    
    ROM_NAME="$(find ./bin/*/*/ -type f -name '*-factory.bin' -printf "%f\n")"
    ROM_PATH="$(find ./bin/*/*/ -type f -name $ROM_NAME -print)"
    DIR_ROM="$(dirname $ROM_PATH)"
    sudo chmod -R 750 $DIR_ROM
    rm -rf $DIR_ROM/packages
    dd if="$ROM_PATH" bs=4M count=1 | cat - "$ROM_PATH" > "$DIR_ROM/pbboot_breed_${ROM_PATH##*/}"
    sudo chmod -R 750 $DIR_ROM
fi