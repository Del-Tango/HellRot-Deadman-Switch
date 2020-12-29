#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# ACTIONS

function compute_action_deadman_switch () {
    info_msg "Triggering dead man switch. Press ${MAGENTA}Ctrl-C${RESET}"\
        "to halt machine decomposition."
    trap_interrupt_signal
    TRIGGER_COUNT=0
    for level_number in `seq 0 9`; do
        defcon_lvl="Defcon${level_number}"
        info_msg "Triggering (${RED}$defcon_lvl${RESET}) machine rot..."
        trigger_machine_decomposition "$defcon_lvl"
        if [ $? -ne 0 ]; then
            warning_msg "Something went wrong."\
                "Could not trigger ${RED}$defcon_lvl${RESET}"\
                "machine decomposition."
        fi
        TRIGGER_COUNT=$((TRIGGER_COUNT + 1))
        if [ $TRIGGER_COUNT -eq ${#HR_DECOMPOSE[@]} ]; then
            done_msg "Decomposition complete for"\
                "${BLUE}`hostname`${RESET} machine."
            return 0
        fi
        info_msg "Halting decomposition for another"\
            "${WHITE}${MD_DEFAULT['rot-time']}${RESET}."
        sleep ${MD_DEFAULT['rot-time']}
    done
    return 0
}

function action_deadman_switch () {
    perform_dead_man_switch_final_checks
    if [ $? -ne 0 ]; then
        error_msg "Something went wrong."\
            "${BLUE}$SCRIPT_NAME${RESET} final checks not passed."
        return 0
    fi
    done_msg "${BLUE}$SCRIPT_NAME${RESET} final checks passed."
    case "$HR_SILENT" in
        'on')
            warning_msg "Executing in silent mode."
            compute_action_deadman_switch &> /dev/null
            ;;
        *)
            compute_action_deadman_switch
            ;;
    esac
    return $?
}

function action_set_rot_script () {
    echo
    DECLARED_DEFCON_LEVELS=( `fetch_declared_defcon_levels` )
    debug_msg "Declared Defcon levels: ${DECLARED_DEFCON_LEVELS[@]}"
    info_msg "Select Defcon level to set machine decomposition script for.
    "
    DEFCON_LEVEL=`fetch_selection_from_user 'Defcon' ${DECLARED_DEFCON_LEVELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    debug_msg "Defcon level selected by user: $DEFCON_LEVEL"
    echo; while :
    do
        info_msg "Type absolute file path, - to clear level,"\
            "or ${MAGENTA}.back${RESET}."
        ROT_SCRIPT=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        elif [[ "$ROT_SCRIPT" != '-' ]]; then
            check_file_exists "$ROT_SCRIPT"
            if [ $? -ne 0 ]; then
                warning_msg "File ${RED}$ROT_SCRIPT${RESET} not found."
                echo; continue
            fi
        fi
        break
    done
    echo; set_defcon_level_rot_script "$DEFCON_LEVEL" "$ROT_SCRIPT"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${RED}$DEFCON_LEVEL${RESET} machine decomposition"\
            "script ${RED}$ROT_SCRIPT${RESET}."
    else
        ok_msg "Successfully set ${RED}$DEFCON_LEVEL${RESET}"\
            "machine decomposition script ${GREEN}$ROT_SCRIPT${RESET}"
    fi
    return $EXIT_CODE
}

function action_edit_rot_script () {
    echo
    DECLARED_DEFCON_LEVELS=( `fetch_declared_defcon_levels` )
    debug_msg "Declared Defcon levels: ${DECLARED_DEFCON_LEVELS[@]}"
    DEFCON_LEVEL=`fetch_selection_from_user 'Defcon' ${DECLARED_DEFCON_LEVELS[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    debug_msg "Defcon level selected by user: $DEFCON_LEVEL"
    ROT_SCRIPT=`fetch_defcon_level_rot_script_path "$DEFCON_LEVEL"`
    if [ $? -ne 0 ]; then
        echo; warning_msg "No decomposition script path set for"\
            "${RED}$DEFCON_LEVEL${RESET}."
        return 2
    fi
    echo; info_msg "Editing ${RED}$DEFCON_LEVEL${RESET}"\
        "machine decomposition script ${YELLOW}$ROT_SCRIPT${RESET}"
    ${MD_DEFAULT['file-editor']} $ROT_SCRIPT
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not edit ${RED}$DEFCON_LEVEL${RESET}"\
            "machine decomposition script ${RED}$ROT_SCRIPT${RESET}."
    else
        check_file_empty "$ROT_SCRIPT"
        if [ $? -eq 0 ]; then
            warning_msg "Machine decomposition script"\
                "${RED}$ROT_SCRIPT${RESET} is empty."
            return 3
        fi
        ok_msg "Successfully edited ${RED}$DEFCON_LEVEL${RESET}"\
            "machine decomposition script ${GREEN}$ROT_SCRIPT${RESET}."
    fi
    return $EXIT_CODE
}

function action_set_silent_on () {
    echo; warning_msg "When ${BLUE}$SCRIPT_NAME${RESET} is silenced,"\
        "it will not report any Defcon levels or decomposition progress."
    fetch_ultimatum_from_user "Are you sure about this? ${YELLOW}Y/N${RESET}"
    echo; if [ $? -ne 0 ]; then
        info_msg "Aborting action."
        return 1
    fi
    set_silent 'on'
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${BLUE}$SCRIPT_NAME${RESET} silence"\
            "to ${GREEN}ON${RESET}."
    else
        ok_msg "Succesfully set ${BLUE}$SCRIPT_NAME${RESET} silence"\
            "to ${GREEN}ON${RESET}."
    fi
    return $EXIT_CODE
}

function action_set_silent_off () {
    echo; warning_msg "When ${BLUE}$SCRIPT_NAME${RESET} is not silenced,"\
        "it will report all triggered Defcon levels and decomposition progress."
    fetch_ultimatum_from_user "Are you sure about this? ${YELLOW}Y/N${RESET}"
    echo; if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    set_silent 'off'
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${BLUE}$SCRIPT_NAME${RESET} silence"\
            "to ${RED}OFF${RESET}."
    else
        ok_msg "Succesfully set ${BLUE}$SCRIPT_NAME${RESET} silence"\
            "to ${RED}OFF${RESET}."
    fi
    return $EXIT_CODE
}

function action_set_rot_interval () {
    echo; info_msg "Type machine decomposition interval or ${MAGENTA}.back${RESET}."
    info_msg "Valid intervals are"\
        "${WHITE}N${MAGENTA}(s - seconds, m - minutes, h - hours, d - days)${RESET}"
    while :
    do
        ROT_TIME=`fetch_data_from_user 'RotTime'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_valid_rot_interval "$ROT_TIME"
        if [ $? -ne 0 ]; then
            echo; warning_msg "Illegal data set. ${RED}$ROT_TIME${RESET}"\
                "is not a valid decomposition interval."
            symbol_msg "${BLUE}EXAMPLE${RESET}" "RotTime> 3h"
            echo; continue
        fi; break
    done
    set_rot_interval "$ROT_TIME"
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${RED}$ROT_TIME${RESET} as"\
            "${BLUE}$SCRIPT_NAME${RESET} machine decomposition interval."
    else
        ok_msg "Successfully set machine decomposition interval"\
            "${GREEN}$ROT_TIME${RESET}."
    fi
    return $EXIT_CODE

}

function action_install_dependencies () {
    echo
    fetch_ultimatum_from_user "Are you sure about this? ${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    apt_install_dependencies
    return $?
}

function action_set_temporary_file () {
    echo; info_msg "Type absolute file path or ${MAGENTA}.back${RESET}."
    while :
    do
        FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File ${RED}$FILE_PATH${RESET} does not exists."
            echo; continue
        fi; break
    done
    set_temporary_file "$FILE_PATH"
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${RED}$FILE_PATH${RESET} as"\
            "${BLUE}$SCRIPT_NAME${RESET} temporary file."
    else
        ok_msg "Successfully set temporary file ${GREEN}$FILE_PATH${RESET}."
    fi
    return $EXIT_CODE
}

function action_set_safety_on () {
    echo; qa_msg "Getting scared, are we?"
    fetch_ultimatum_from_user "${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    set_safety 'on'
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${BLUE}$SCRIPT_NAME${RESET} safety"\
            "to ${GREEN}ON${RESET}."
    else
        ok_msg "Succesfully set ${BLUE}$SCRIPT_NAME${RESET} safety"\
            "to ${GREEN}ON${RESET}."
    fi
    return $EXIT_CODE
}

function action_set_safety_off () {
    echo; qa_msg "Taking off the training wheels. Are you sure about this?"
    fetch_ultimatum_from_user "${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
    fi
    set_safety 'off'
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${BLUE}$SCRIPT_NAME${RESET} safety"\
            "to ${RED}OFF${RESET}."
    else
        ok_msg "Succesfully set ${BLUE}$SCRIPT_NAME${RESET} safety"\
            "to ${RED}OFF${RESET}."
    fi
    return $EXIT_CODE
}

function action_set_log_file () {
    echo; info_msg "Type absolute file path or ${MAGENTA}.back${RESET}."
    while :
    do
        FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File ${RED}$FILE_PATH${RESET} does not exists."
            echo; continue
        fi; break
    done
    echo; set_log_file "$FILE_PATH"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${RED}$FILE_PATH${RESET} as"\
            "${BLUE}$SCRIPT_NAME${RESET} log file."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} log file"\
            "${GREEN}$FILE_PATH${RESET}."
    fi
    return $EXIT_CODE
}

function action_set_log_lines () {
    echo; info_msg "Type log line number to display or ${MAGENTA}.back${RESET}."
    while :
    do
        LOG_LINES=`fetch_data_from_user 'LogLines'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_value_is_number $LOG_LINES
        if [ $? -ne 0 ]; then
            warning_msg "LogViewer number of lines requiered,"\
                "not ${RED}$LOG_LINES${RESET}."
            echo; continue
        fi; break
    done
    echo; set_log_lines $LOG_LINES
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${BLUE}$SCRIPT_NAME${RESET} default"\
            "${RED}log lines${RESET} to (${RED}$LOG_LINES${RESET})."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} default"\
            "${GREEN}log lines${RESET} to (${GREEN}$LOG_LINES${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_file_editor () {
    echo; info_msg "Type file editor name or ${MAGENTA}.back${RESET}."
    while :
    do
        FILE_EDITOR=`fetch_data_from_user 'Editor'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_util_installed "$FILE_EDITOR"
        if [ $? -ne 0 ]; then
            warning_msg "File editor ${RED}$FILE_EDITOR${RESET} is not installed."
            echo; continue
        fi; break
    done
    set_file_editor "$FILE_EDITOR"
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${RED}$FILE_EDITOR${RESET} as"\
            "${BLUE}$SCRIPT_NAME${RESET} default file editor."
    else
        ok_msg "Successfully set default file editor"\
            "${GREEN}$FILE_EDITOR${RESET}."
    fi
    return $EXIT_CODE
}

