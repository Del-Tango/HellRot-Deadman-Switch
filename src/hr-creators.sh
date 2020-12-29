#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# CREATORS

function create_file () {
    local FILE_PATH="$1"
    symbol_msg "${GREEN}+${RESET}" "Creating file ${YELLOW}$FILE_PATH${RESET}..."
    touch $FILE_PATH
    return $?
}

function create_directory() {
    local DIRECTORY_PATH="$1"
    symbol_msg "${GREEN}+${RESET}" "Creating directory ${YELLOW}$DIRECTORY_PATH${RESET}..."
    mkdir $DIRECTORY_PATH
    return $?
}

function create_hellrot_menu_controllers () {

    create_main_menu_controller
    create_log_viewer_menu_cotroller
    create_settings_menu_controller
    done_msg "${BLUE}$SCRIPT_NAME${RESET} controller construction complete."

    return 0
}

function create_main_menu_controller () {

    info_msg "Creating menu controller"\
        "${YELLOW}$MAIN_CONTROLLER_LABEL${RESET}..."
    add_menu_controller "$MAIN_CONTROLLER_LABEL" \
        "$MAIN_CONTROLLER_DESCRIPTION"

    info_msg "Setting ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} options..."
    set_menu_controller_options "$MAIN_CONTROLLER_LABEL" \
        "$MAIN_CONTROLLER_OPTIONS"

    return 0
}

function create_log_viewer_menu_cotroller () {

    info_msg "Creating menu controller"\
        "${YELLOW}$LOGVIEWER_CONTROLLER_LABEL${RESET}..."
    add_menu_controller "$LOGVIEWER_CONTROLLER_LABEL" \
        "$LOGVIEWER_CONTROLLER_DESCRIPTION"

    info_msg "Setting ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} options..."
    set_menu_controller_options "$LOGVIEWER_CONTROLLER_LABEL" \
        "$LOGVIEWER_CONTROLLER_OPTIONS"

    return 0
}

function create_settings_menu_controller () {

    info_msg "Creating menu controller"\
        "${YELLOW}$SETTINGS_CONTROLLER_LABEL${RESET}..."
    add_menu_controller "$SETTINGS_CONTROLLER_LABEL" \
        "$SETTINGS_CONTROLLER_DESCRIPTION"

    info_msg "Setting ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} options..."
    set_menu_controller_options "$SETTINGS_CONTROLLER_LABEL" \
        "$SETTINGS_CONTROLLER_OPTIONS"

    info_msg "Setting ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} extented"\
        "banner function ${MAGENTA}display_hellrot_settings${RESET}..."
    set_menu_controller_extended_banner "$SETTINGS_CONTROLLER_LABEL" \
        'display_hellrot_settings'

    return 0
}

