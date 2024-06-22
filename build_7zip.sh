#!/bin/bash
set -eo pipefail

export CCACHE_DIR="$GITHUB_WORKSPACE/.ccache"

case $ARCH in
  x86_64)
    PLATFORM=x64
    MAKE_OPTS="MY_ASM=uasm -f ../../cmpl_gcc_$PLATFORM.mak";;
  x86)
    PLATFORM=x86
    MAKE_OPTS="MY_ASM=uasm -f ../../cmpl_gcc_$PLATFORM.mak";;
  aarch64)
    PLATFORM=arm64
    MAKE_OPTS="MY_ASM=uasm -f ../../cmpl_gcc_$PLATFORM.mak";;
  armhf)
    PLATFORM=arm
    MAKE_OPTS="-f ../../cmpl_gcc_$PLATFORM.mak";;
  *)
    PLATFORM=$ARCH
    MAKE_OPTS="-f ../../cmpl_gcc.mak";;
esac

git ls-files -z | xargs -0 unix2dos -q --allow-chown && (QUILT_PATCHES=../patches quilt push -a || exit 1)

( cd CPP/7zip/Bundles/Alone2 && mkdir -p b/g && \
  make -j$(nproc) \
    CC="ccache gcc" CXX="ccache g++" \
    CFLAGS_BASE_LIST="-c -D_7ZIP_AFFINITY_DISABLE=1 -DZ7_AFFINITY_DISABLE=1 -D_GNU_SOURCE=1" \
    CFLAGS_WARN_WALL="-Wall -Wextra" COMPL_STATIC=1 $MAKE_OPTS || exit 1 )

find . -type f -name '7zzs' -exec cp -va {} 7zz \; && tar -cJvf $GITHUB_WORKSPACE/7zz-linux-$PLATFORM.tar.xz 7zz

ccache --max-size=50M --show-stats
