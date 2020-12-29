#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETTERS

function set_defcon_level_rot_script () {
    local DEFCON_LEVEL="$1"
    local SCRIPT_PATH="$2"
    if [[ "$SCRIPT_PATH" == '-' ]]; then
        HR_DECOMPOSE[$DEFCON_LEVEL]=
        return 0
    fi
    check_file_exists "$SCRIPT_PATH"
    if [ $? -ne 0 ]; then
        error_msg "File machine decomposition script"\
            "${RED}$SCRIPT_PATH${RESET} not found."
        return 1
    fi
    HR_DECOMPOSE[$DEFCON_LEVEL]=$SCRIPT_PATH
    return 0
}

function set_silent () {
    local SILENT="$1"
    if [[ "$SILENT" != 'on' ]] && [[ "$SILENT" != 'off' ]]; then
        error_msg "Invalid safety value ${RED}$SILENT${RESET}."\
            "Defaulting to ${RED}OFF${RESET}."
        HR_SILENT='off'
        return 1
    fi
    HR_SILENT=$SILENT
    return 0
}

function set_rot_interval () {
    local ROT_INTERVAL="$1"
    check_valid_rot_interval "$ROT_INTERVAL"
    if [ $? -ne 0 ]; then
        error_msg "Illegal data set. ${RED}$ROT_INTERVAL${RESET}"\
            "is not a valid rot interval."
        return 1
    fi
    MD_DEFAULT['rot-time']="$ROT_INTERVAL"
    return 0
}

function set_log_file () {
    local FILE_PATH="$1"
    check_file_exists "$FILE_PATH"
    if [ $? -ne 0 ]; then
        error_msg "File ${RED}$FILE_PATH${RESET} does not exist."
        return 1
    fi
    MD_DEFAULT['log-file']="$FILE_PATH"
    return 0
}

function set_log_lines () {
    local LOG_LINES=$1
    if [ -z "$LOG_LINES" ]; then
        error_msg "Log line value ${RED}$LOG_LINES${RESET} is not a number."
        return 1
    fi
    MD_DEFAULT['log-lines']=$LOG_LINES
    return 0
}


