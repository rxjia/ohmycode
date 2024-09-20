#!/usr/bin/env zsh
#set -e

# Only set when this is not setup
SHELL_FOLDER=$(dirname "$(realpath "${BASH_SOURCE:-$0}")")
PROJECT_ROOT=$(cd "$(dirname "${SHELL_FOLDER}")"/..;pwd)

# if IN_MY_ENV exist and IN_MY_ENV == $SHELL_FOLDER, then return
if [ ! -z $IN_MY_ENV ] && [ $IN_MY_ENV = $SHELL_FOLDER ]; then
    return
fi
export IN_MY_ENV=${PROJECT_ROOT}

# Get Variables
HOSTNAME=$(hostname)

# echo ZSH=$ZSH
# echo ZSH_THEME=$ZSH_THEME

# if not exist ZSH_THEME source zshrc
if [ ! -z $ZSH_THEME ]; then
    source ~/.zshrc
fi

if [ -f "${SHELL_FOLDER}/local_source.sh" ]; then
    source ${SHELL_FOLDER}/local_source.sh
fi

# Load env config file ----------------
ENABLE_VERBOSE=
ENABLE_REP=
ROS_WS=
CONDA_ENV_NAME=

ENV_FILE="${SHELL_FOLDER}/.env"
# echo ${ENV_FILE}
if [ -f $ENV_FILE ]; then
    # This ignores empty lines, and lines starting with # (comments). If you replace eval with echo - you can inspect the generated code.
    eval "$(
        cat ${ENV_FILE} | awk '!/^\s*#/' | awk '!/^\s*$/' | while IFS='' read -r line; do
            key=$(echo "$line" | cut -d '=' -f 1)
            value=$(echo "$line" | cut -d '=' -f 2-)
            if [ ! $value ];then
                echo "export $key="
            else
                echo "export $key=\"$value\""
            fi
        done
    )"
fi

# =====================================

# Check IDE env ----------------
IN_VSCODE=
IN_PYCHARM=

if [ "${TERM_PROGRAM}" = "vscode" ]; then
    IN_VSCODE=1
    export PROMPT='[Env]'"${PROMPT}"
fi
if [ "${PYCHARM_HOSTED}" ]; then
    IN_PYCHARM=1
fi

# DISPLAY
export DISPLAY=:0

# PYREP ------------------------------
if [[ ${ENABLE_REP} == 1 ]]; then
    if [ "$HOSTNAME" = "ubuntu-Z490-UD" ]; then
        export COPPELIASIM_ROOT=/opt/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04
    elif [ "$HOSTNAME" != "rs-tower" ]; then
        export COPPELIASIM_ROOT=/opt/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04
    else
        export COPPELIASIM_ROOT=/opt/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04
    fi

    if [ -z $COPPELIASIM_ROOT ]; then
        echo "Warn! COPPELIASIM_ROOT not set!"
    fi
    
    export LD_LIBRARY_PATH=$COPPELIASIM_ROOT:$LD_LIBRARY_PATH
    export QT_QPA_PLATFORM_PLUGIN_PATH=$COPPELIASIM_ROOT
fi

# IDE ------------------------------
# echo "IN_VSCODE: ${IN_VSCODE}"
# echo "IN_PYCHARM: ${IN_PYCHARM}"

# if not in pycharm
#if [ -z "${IN_PYCHARM}" ]; then
##    echo "load .env"
#    export $(grep -v '^#' ${SHELL_FOLDER}/../.env | xargs)
#fi

# PYTHONPATH ------------------------------
# export PYTHONPATH=$PROJECT_ROOT/src:$PYTHONPATH

# ROS ------------------------------
# check current shell is zsh
if [ -n "$ZSH_VERSION" ]; then
    # assume Zsh
    # echo "Zsh"
    export SHELL_NAME="zsh"
elif [ -n "$BASH_VERSION" ]; then
    # assume Bash
    # echo "Bash"
    export SHELL_NAME="bash"
fi
# echo SHELL_NAME: ${SHELL_NAME}
# SHELL_NAME="bash"
# if set ROS_WS then source it
if [ ! -z ${ROS_WS} ]; then
    if [ "$ROS_VERSION" == "1" ]; then
        if [ $SHELL_NAME == "bash" ]; then
            source ${ROS_WS}/devel/setup.bash
        elif [ $SHELL_NAME == "zsh" ]; then
            source ${ROS_WS}/devel/setup.zsh
        fi
    elif [ "$ROS_VERSION" == "2" ]; then
        if [ $SHELL_NAME == "bash" ]; then
            source ${ROS_WS}/install/setup.bash
        elif [ $SHELL_NAME == "zsh" ]; then
            source ${ROS_WS}/install/setup.zsh
        fi
    fi
fi

# Activate conda ------------------------------
if [ ! -z $CONDA_ENV_NAME ]; then
    if [ -f "${SHELL_FOLDER}/conda_activate.sh" ]; then
        source "${SHELL_FOLDER}/conda_activate.sh" ${CONDA_ENV_NAME}
    else
        echo "Warn! not find conda_activate.sh!"
    fi
fi
