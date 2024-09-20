#!/usr/bin/env bash
# set -e

CONDA_EXE=${CONDA_EXE:-"/opt/conda/bin/conda"}
CONDA_ENV_NAME=$1

CONDA_BIN_DIR=$(cd "$(dirname "$CONDA_EXE")";pwd)

if [ "${CONDA_EXE}" ]; then
    if [ "${CONDA_ENV_NAME}" ]; then
        source ${CONDA_BIN_DIR}/activate ${CONDA_ENV_NAME}
#        echo "Enter conda env: ${CONDA_ENV_NAME}"
    else
        echo "Err!!!  Please type arg 'CONDA_ENV_NAME'.\ne.g. source conda_activate.sh CONDA_ENV_NAME"
    fi
    unset CONDA_ENV_NAME
else
    echo "Err!!! Please manually input CONDA_BIN_DIR "
    exit -1
fi
unset CONDA_ENV_NAME
