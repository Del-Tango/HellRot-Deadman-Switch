#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# GENERAL

function trap_interrupt_signal () {
    trap 'trap - SIGINT; echo " Halting machine rot."; return 0' SIGINT
    return 0
}

function perform_dead_man_switch_final_checks () {
    echo; check_defcon_levels_declared
    if [ $? -ne 0 ]; then
        nok_msg "No ${BLUE}$SCRIPT_NAME${RESET} Defcon levels declared."
        return 1
    else
        ok_msg "${BLUE}$SCRIPT_NAME${RESET} declared Defcon levels confirmed."
    fi
    check_existing_machine_decomposition_scripts
    if [ $? -ne 0 ]; then
        nok_msg "No ${BLUE}$SCRIPT_NAME${RESET} machine decomposition"\
            "scripts found."
        return 2
    else
        ok_msg "${BLUE}$SCRIPT_NAME${RESET}"\
            "existing machine decomposition scripts confirmed."
    fi
    check_rot_time_set
    if [ $? -ne 0 ]; then
        nok_msg "${BLUE}$SCRIPT_NAME${RESET} rot interval not set."
        return 3
    else
        ok_msg "${BLUE}$SCRIPT_NAME${RESET} set rot interval confirmed."
    fi
    return 0
}

function trigger_machine_decomposition () {
    local DEFCON_LEVEL="$1"
    ROT_SCRIPT=`fetch_defcon_level_rot_script_path "$DEFCON_LEVEL"`
    if [ $? -ne 0 ]; then
        echo; info_msg "No ${RED}$DEFCON_LEVEL${RESET}"\
            "machine decomposition script found. No action taken."
        echo; return 0
    fi
    check_safety_on
    if [ $? -eq 0 ]; then
        echo; warning_msg "${BLUE}$SCRIPT_NAME${RESET} safety is ${GREEN}ON${RESET}."
        info_msg "${RED}$DEFCON_LEVEL${RESET} machine decomposition bypassed."
        return 1
    fi
    echo; ${HR_DECOMPOSE[$DEFCON_LEVEL]}; echo
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong"\
            "${RED}$DEFCON_LEVEL${RESET} machine decomposition failure."
    else
        ok_msg "Successfully carried out ${RED}$DEFCON_LEVEL${RESET}"\
            "rot using ${GREEN}${HR_DECOMPOSE[$DEFCON_LEVEL]}${RESET}."
    fi
    return $EXIT_CODE
}
