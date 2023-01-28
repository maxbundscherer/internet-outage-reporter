#!/bin/bash

####################################################################
#################### CONFIG SECTION ################################
####################################################################

config_ifttt_key="" # Enter your IFTTT key here

config_local_path="/tmp" # Enter your local file save path here (please only use absolute paths)

config_my_location="Home" # Enter your location here (please only use a single word)

config_ifttt_event_name="ior" # Enter your IFTTT event name here (default is ior)

####################################################################
#################### SCRIPT SECTION ################################
####################################################################

CURRENT_TIME=$(date +"%Y-%m-%d-at-%H:%M:%S")

PATH_TO_FILE_LAST_CHECK="$config_local_path/last-check.txt"
PATH_TO_FILE_FIRST_DOWNTIME="$config_local_path/first-downtime.txt"

echo
echo "Last-Check Path '$PATH_TO_FILE_LAST_CHECK'"
echo "First-Downtime Path '$PATH_TO_FILE_FIRST_DOWNTIME'"
echo

if [ "$1" = "-test" ]; then

    # Send test notifcation

    send_data="Test-Notification<BR>$config_my_location<BR><BR>$CURRENT_TIME"

    r=$(
        curl \
        -X POST \
        -H "Content-Type: application/json" \
        -d '{"value1":"'$send_data'"}' \
        "https://maker.ifttt.com/trigger/$config_ifttt_event_name/with/key/$config_ifttt_key"
    )

    echo ""

    if [[ "$r" == *"Congratulations"* ]]; then
        echo "Success send test notification"
    else
        echo "Failure send test notification"
        echo $r
    fi

elif [ "$1" = "-check" ]; then

    # Test internet connection

    echo "$CURRENT_TIME" > "$PATH_TO_FILE_LAST_CHECK"

    if nc -zw1 google.com 443; then

        # "Internet connection"
        echo "Internet connection is up"

        if [ -f "$PATH_TO_FILE_FIRST_DOWNTIME" ]; then

            # Internet was down in the past

            f_downtime=$(cat "$PATH_TO_FILE_FIRST_DOWNTIME")
            echo "Internet connection was down in the past '$f_downtime'"

            send_data="Internet-Down-Notification<BR>$config_my_location<BR><BR>$f_downtime<BR>$CURRENT_TIME"

            r=$(
                curl \
                -X POST \
                -H "Content-Type: application/json" \
                -d '{"value1":"'$send_data'"}' \
                "https://maker.ifttt.com/trigger/$config_ifttt_event_name/with/key/$config_ifttt_key"
            )

            if [[ "$r" == *"Congratulations"* ]]; then
                echo "Success send down notification"
                rm "$PATH_TO_FILE_FIRST_DOWNTIME"
            else
                echo "Failure send down notification"
            fi

        fi
        
    else

        # "No internet connection"

        if [ -f "$PATH_TO_FILE_FIRST_DOWNTIME" ]; then

            # Was down until now
            echo "Internet connection is down (was down until now)"

        else

            # Down for the first time
            echo "Internet connection is down (down for the first time)"
            echo "$CURRENT_TIME" > "$PATH_TO_FILE_FIRST_DOWNTIME"

        fi

    fi

else
    echo "Please specify a valid argument: -test or -check"
fi
