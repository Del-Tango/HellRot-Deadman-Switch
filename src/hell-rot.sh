#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# HELL ROT - Machine Decomposition :)

function load_hellrot_logging_levels () {
    if [ ${#HR_LOGGING_LEVELS[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} logging levels found."
        return 1
    fi
    MD_LOGGING_LEVELS=( ${HR_LOGGING_LEVELS[@]} )
    ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} logging levels."
    return 0
}

function load_settings_hellrot_default () {
    if [ ${#HR_DEFAULT[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} defaults found."
        return 1
    fi
    for hb_setting in ${!HR_DEFAULT[@]}; do
        MD_DEFAULT[$hb_setting]=${HR_DEFAULT[$hb_setting]}
        ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET}"\
            "default setting"\
            "(${GREEN}$hb_setting - ${HR_DEFAULT[$hb_setting]}${RESET})."
    done
    done_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} default settings."
    return 0
}

function load_hellrot_safety_default () {
    if [ -z "$HR_SAFETY" ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} default safety value"\
            "found. Defaulting to $MD_SAFETY."
        return 1
    fi
    set_safety "$HR_SAFETY"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load ${BLUE}$SCRIPT_NAME${RESET} default safety"\
            "value ${RED}$HR_SAFETY${RESET}."
    else
        ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET}"\
            "default safety value ${GREEN}$HR_SAFETY${RESET}."
    fi
    return $EXIT_CODE
}

function load_hellrot_script_name () {
    if [ -z "$HR_SCRIPT_NAME" ]; then
        warning_msg "No default script name found. Defaulting to $SRIPT_NAME."
        return 1
    fi
    set_project_name "$HR_SCRIPT_NAME"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load script name ${RED}$HR_SCRIPT_NAME${RESET}."
    else
        ok_msg "Successfully loaded"\
            "script name ${GREEN}$HR_SCRIPT_NAME${RESET}"
    fi
    return $EXIT_CODE
}

function load_hellrot_prompt_string () {
    if [ -z "$HR_PS3" ]; then
        warning_msg "No default prompt string found. Defaulting to $MD_PS3."
        return 1
    fi
    set_project_prompt "$HR_PS3"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load prompt string ${RED}$HR_PS3${RESET}."
    else
        ok_msg "Successfully loaded"\
            "prompt string ${GREEN}$HR_PS3${RESET}"
    fi
    return $EXIT_CODE
}

function load_hellrot_config () {
    load_hellrot_script_name
    load_hellrot_prompt_string
    load_settings_hellrot_default
    load_hellrot_safety_default
    load_hellrot_logging_levels
}

function hellrot_project_setup () {
    lock_and_load
    load_hellrot_config
    create_hellrot_menu_controllers
    setup_hellrot_menu_controllers
}

