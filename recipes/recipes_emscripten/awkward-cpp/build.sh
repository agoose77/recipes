#!/usr/bin/env bash

# Setup toolchain from pyodide-build
toolchain_path="$(python3 ${RECIPE_DIR}/find-pyodide-build-platform.py)"

# Setup build arguments
export CMAKE_ARGS="${CMAKE_ARGS} -DEMSCRIPTEN=1 -DCMAKE_TOOLCHAIN_FILE=${toolchain_path}"

python -m pip install . -vv
