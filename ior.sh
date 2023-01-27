
if [ "$1" = "-test" ]; then

    echo "hello"

elif [ "$1" = "-check" ]; then

    echo "bye"

else
    echo "Please specify a valid argument: -test or -check"
fi
