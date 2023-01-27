#!/bin/bash

####################################################################
#################### CONFIG SECTION ################################
####################################################################

config_ifttt_event_name="ior"                                  # Enter your IFTTT event name here (default is ior)
config_ifttt_key="" # Enter your IFTTT key here

####################################################################
#################### SCRIPT SECTION ################################
####################################################################

CURRENT_TIME=$(date +"%Y-%m-%d-at-%H:%M:%S")

if [ "$1" = "-test" ]; then

    # Send test notifcation

    send_data="Test-Notification<BR>$CURRENT_TIME"

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

    echo "$CURRENT_TIME" > last-check.txt

    if nc -zw1 google.com 443; then

        # "Internet connection"
        echo "Internet connection is up"

        if [ -f first-downtime.txt ]; then

            # Internet was down in the past

            f_downtime=$(cat first-downtime.txt)
            echo "Internet connection was down in the past '$f_downtime'"

            send_data="Internet-Down-Notification<BR>$f_downtime<BR>$CURRENT_TIME"

            r=$(
                curl \
                -X POST \
                -H "Content-Type: application/json" \
                -d '{"value1":"'$send_data'"}' \
                "https://maker.ifttt.com/trigger/$config_ifttt_event_name/with/key/$config_ifttt_key"
            )

            if [[ "$r" == *"Congratulations"* ]]; then
                echo "Success send down notification"
                rm first-downtime.txt
            else
                echo "Failure send down notification"
            fi

        fi
        
    else

        # "No internet connection"

        if [ -f first-downtime.txt ]; then

            # Was down until now
            echo "Internet connection is down (was down until now)"

        else

            # Down for the first time
            echo "Internet connection is down (down for the first time)"
            echo "$CURRENT_TIME" > first-downtime.txt

        fi

    fi

else
    echo "Please specify a valid argument: -test or -check"
fi
