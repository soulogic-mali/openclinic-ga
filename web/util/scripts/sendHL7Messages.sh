#!/bin/bash
delay=60
while true; do
        echo "Sending HL7 messages..."
        cd /var/tomcat/webapps/openclinic/util
        ./sendHL7.sh
        echo "...done"
        echo "Sleeping for ${1:-$delay} second(s)"
        sleep ${1:-$delay}
done
