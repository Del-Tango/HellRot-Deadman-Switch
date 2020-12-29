#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# FETCHERS

function fetch_defcon_level_rot_script_path () {
    local DEFCON_LEVEL="$1"
    check_valid_defcon_level "$DEFCON_LEVEL"
    if [ $? -ne 0 ]; then
        error_msg "Illegal data set."\
            "${RED}$DEFCON_LEVEL${RESET} is not a Defcon level."
        return 1
    fi
    debug_msg "Defcon level $DEFCON_LEVEL passed validity check."
    debug_msg "Defcon level $DEFCON_LEVEL rot script path:"\
        "${HR_DECOMPOSE[$DEFCON_LEVEL]}"
    if [ -z "${HR_DECOMPOSE[$DEFCON_LEVEL]}" ]; then
        warning_msg "No decomposition script path found for"\
            "${RED}$DEFCON_LEVEL${RESET}."
        return 2
    fi
    echo "${HR_DECOMPOSE[$DEFCON_LEVEL]}"
    return 0
}

function fetch_declared_defcon_levels () {
    if [ ${#HR_DECOMPOSE[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} Defcon levels declared."
        return 1
    fi
    echo ${!HR_DECOMPOSE[@]} | sort -g
    return 0
}

function fetch_valid_rot_interval_regex () {
    echo '^[0-9]{1,3}[smhd]'
    return $?
}

function fetch_multiline_data_from_user () {
    if [ -z "${MD_DEFAULT['file-editor']}" ]; then
        error_msg "No ${RED}$SCRIPT_NAME${RESET} default file editor found."
        return 1
    fi
    ${MD_DEFAULT['file-editor']} ${MD_DEFAULT['tmp-file']}
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        warning_msg "Something went wrong."\
            "Could not fetch multiline data from user."
    fi
    check_file_empty "${MD_DEFAULT['tmp-file']}"
    if [ $? -eq 0 ]; then
        warning_msg "No data input from user."\
            "File ${RED}${MD_DEFAULT['tmp-file']}${RESET} is empty."
        return 2
    fi
    return $EXIT_CODE
}
