#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# CHECKERS

function check_defcon_levels_declared () {
    fetch_declared_defcon_levels &> /dev/null
    return $?
}

function check_existing_machine_decomposition_scripts () {
    for rot_script in ${!HR_DECOMPOSE[@]}; do
        if [ ! -z "$rot_script" ]; then
            check_file_exists "${HR_DECOMPOSE[$rot_script]}"
            if [ $? -ne 0 ]; then
                continue
            fi
            return 0
        fi
    done
    return 1
}

function check_rot_time_set () {
    if [ -z "${HR_DEFAULT['rot-time']}" ]; then
        return 1
    fi
    VALID_ROT_INTERVAL_REGEX=`fetch_valid_rot_interval_regex`
    echo "${HR_DEFAULT['rot-time']}" | \
        egrep -e "$VALID_ROT_INTERVAL_REGEX" &> /dev/null
    return $?
}

function check_valid_defcon_level () {
    local DEFCON_LEVEL="$1"
    VALID_DEFCON_LEVELS=( `fetch_declared_defcon_levels` )
    debug_msg "Valid defcon levels: ${MAGENTA}${VALID_DEFCON_LEVELS[@]}${RESET}"
    check_item_in_set "$DEFCON_LEVEL" ${VALID_DEFCON_LEVELS[@]}
    return $?
}

function check_valid_rot_interval () {
    local ROT_INTERVAL="$1"
    ROT_INTERVAL_REGEX=`fetch_valid_rot_interval_regex`
    debug_msg "Machine decomposition interval regex: $ROT_INTERVAL_REGEX"
    echo "$ROT_INTERVAL" | egrep -e "$ROT_INTERVAL_REGEX" &> /dev/null
    return $?
}
