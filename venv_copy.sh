#!/bin/bash
# The path where the virtual enviorments will be stored
envs_path=~/.shell_projects/envs/

_venv_comp() { _files -W ${envs_path} -/; }
compdef _venv_comp venv


function _help() {
    echo "venv.sh is a script to create and activate python virtual environments"
    echo "usage: venv.sh [-h] [-c] [-a] <venv>"
    echo "options:"
    echo "-h: help"
    echo "-c: create virtual environment"
    echo "-d: delete virtual environment"
    echo "-a: activate virtual environment located in the current directory"
}

function _create() {
    echo "creating python virtual environment" $1
    python3 -m venv ${envs_path}$1
    source ${envs_path}$1/bin/activate
}

function _delete() {
    echo "deleting python virtual environment" $1
    rm -rf ${envs_path}$1
}


function _activate() {
    if [ -z "$1" ]
    then
        source venv/bin/activate
        return
    fi
    source $1/bin/activate
}

function _venv_activate() {
    source ${envs_path}$1/bin/activate
}

function venv() {
    while getopts ":hcda" option; do
        shift
        case $option in
            h) # display Help
                _help
                return;;
            c) # create venv
                echo "you passed -c to create a venv"
                _create "$@"
                return;;
            d) # delete venv
                _delete "$@"
                return;;
            a) # activate venv
                _activate "$@"
                return;;
            \?) # Invalid option
                echo "Error: Invalid option, use -h for help."
                return;;
        esac
    done
    _venv_activate "$@"
}

