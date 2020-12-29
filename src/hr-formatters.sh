#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# FORMATTERS

function format_defcon_colors () {
    local DEFCON_LEVEL="$1"
    fetch_defcon_level_rot_script_path "$DEFCON_LEVEL" &> /dev/null
    EXIT_CODE=$?
    case "$EXIT_CODE" in
        '0')
            DISPLAY_DEFCON=${RED}$DEFCON_LEVEL${RESET}
            ;;
        '2')
            DISPLAY_DEFCON=${GREEN}$DEFCON_LEVEL${RESET}
            ;;
        *)
            DISPLAY_DEFCON=$DEFCON_LEVEL
            ;;
    esac
    echo "$DISPLAY_DEFCON"
    return 0
}

