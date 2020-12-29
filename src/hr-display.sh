#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# DISPLAY

function display_hellrot_banner () {
    figlet -f lean -w 1000 "$SCRIPT_NAME" > "${MD_DEFAULT['tmp-file']}"
    clear; echo -n "${BLUE}`cat ${MD_DEFAULT['tmp-file']}`${RESET}"
    echo -n > ${MD_DEFAULT['tmp-file']}
    return 0
}

function display_decomposition_scripts () {
    echo "
[ `format_defcon_colors 'Defcon0'`        ]: ${YELLOW}${HR_DECOMPOSE['Defcon0']}${RESET}
[ `format_defcon_colors 'Defcon1'`        ]: ${YELLOW}${HR_DECOMPOSE['Defcon1']}${RESET}
[ `format_defcon_colors 'Defcon2'`        ]: ${YELLOW}${HR_DECOMPOSE['Defcon2']}${RESET}
[ `format_defcon_colors 'Defcon3'`        ]: ${YELLOW}${HR_DECOMPOSE['Defcon3']}${RESET}
[ `format_defcon_colors 'Defcon4'`        ]: ${YELLOW}${HR_DECOMPOSE['Defcon4']}${RESET}
[ `format_defcon_colors 'Defcon5'`        ]: ${YELLOW}${HR_DECOMPOSE['Defcon5']}${RESET}
[ `format_defcon_colors 'Defcon6'`        ]: ${YELLOW}${HR_DECOMPOSE['Defcon6']}${RESET}
[ `format_defcon_colors 'Defcon7'`        ]: ${YELLOW}${HR_DECOMPOSE['Defcon7']}${RESET}
[ `format_defcon_colors 'Defcon8'`        ]: ${YELLOW}${HR_DECOMPOSE['Defcon8']}${RESET}
[ `format_defcon_colors 'Defcon9'`        ]: ${YELLOW}${HR_DECOMPOSE['Defcon9']}${RESET}
    "
}

function display_hellrot_settings () {
    DISPLAY_SILENT=`format_flag_colors "$HR_SILENT"`
    DISPLAY_SAFETY=`format_flag_colors "$MD_SAFETY"`
    echo "[ ${CYAN}Conf File${RESET}      ]: ${YELLOW}${MD_DEFAULT['conf-file']}${RESET}
[ ${CYAN}Log File${RESET}       ]: ${YELLOW}${MD_DEFAULT['log-file']}${RESET}
[ ${CYAN}Temporary File${RESET} ]: ${YELLOW}${MD_DEFAULT['tmp-file']}${RESET}
[ ${CYAN}File Editor${RESET}    ]: ${MAGENTA}${MD_DEFAULT['file-editor']}${RESET}
[ ${CYAN}Log Lines${RESET}      ]: ${WHITE}${MD_DEFAULT['log-lines']}${RESET}
[ ${CYAN}Rot Interval${RESET}   ]: ${WHITE}${MD_DEFAULT['rot-time']}${RESET}
[ ${CYAN}Silent${RESET}         ]: $DISPLAY_SILENT
[ ${CYAN}Safety${RESET}         ]: $DISPLAY_SAFETY"
    display_decomposition_scripts | column; echo; return 0
}

