#!/bin/bash
set -eo pipefail

#export CCACHE_DIR="$GITHUB_WORKSPACE/.ccache"

#VERSION=$(git describe --tags --abbrev=0)

git ls-files -z | xargs -0 unix2dos --allow-chown && QUILT_PATCHES=../patches quilt push -a

cd CPP/7zip/Bundles/Alone2 && mkdir -p b/g && \
make \
  CC="ccache ${CC:-cc}" CXX="ccache ${CXX:-c++}" && \
  CFLAGS_BASE_LIST="-c -static -D_7ZIP_AFFINITY_DISABLE=1 -DZ7_AFFINITY_DISABLE=1 -D_GNU_SOURCE=1" \
  CFLAGS_WARN_WALL="-Wall -Wextra" MY_ARCH="-static" MY_ASM=uasm \
  -f ../../cmpl_gcc.mak -j"$(nproc)" && \

find . -type f -name 7zz -exec cp -va {} . \; && tar -cJvf ../7zip-$ARCH.tar.xz 7zz

ccache --max-size=50M --show-stats
