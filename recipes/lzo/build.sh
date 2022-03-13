#!/bin/bash
set -ex

if [[ "$target_platform" == "osx-64" ]]; then
  CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_MACOSX_RPATH=ON"
fi

if [[ "${FEATURE_STATIC}" == "1" ]]; then
    SHARED_STATIC="-DENABLE_SHARED=OFF -DENABLE_STATIC=ON"
else
    SHARED_STATIC="-DENABLE_SHARED=ON -DENABLE_STATIC=OFF"
fi

mkdir -p cmake-build
cd cmake-build

cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=${PREFIX} \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
      -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
      ${SHARED_STATIC} \
      ${CMAKE_ARGS} \
      ${SRC_DIR}

make -j${CPU_COUNT} ${VERBOSE_CM}

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  # This is the same as `make test` when not using cmake.
  ./lzotest -mlzo -n2 -q ${SRC_DIR}/COPYING
fi

make -j${CPU_COUNT} install
