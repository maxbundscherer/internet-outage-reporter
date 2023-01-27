####################################################################
#################### CONFIG SECTION ################################
####################################################################

config_ifttt_event_name="ior"                                  # Enter your IFTTT event name here (default is ior)
config_ifttt_key=""                                            # Enter your IFTTT key here

####################################################################
#################### SCRIPT SECTION ################################
####################################################################

if [ "$1" = "-test" ]; then

    # Send test notifcation

    send_data="TestData"

    r=$(
        curl \
        -X POST \
        -H "Content-Type: application/json" \
        -d '{"value1":"'$send_data'"}' \
        "https://maker.ifttt.com/trigger/$config_ifttt_event_name/with/key/$config_ifttt_key"
    )

    echo

    if [[ "$r" == *"Congratulations"* ]]; then
        echo "Success"
    else
        echo "Failure"
        echo $r
    fi

elif [ "$1" = "-check" ]; then

    # Test internet connection

    echo "tbd"

else
    echo "Please specify a valid argument: -test or -check"
fi
