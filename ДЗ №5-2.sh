#!/bin/bash
usage(){
  cat << eof
This script monitors failed login attempts in /var/log/auth.log.
If wrong authentication data entered the script informs that failed login attempt occured and specifies which console was used to log in.
Press Ctrl+C to exit.
Examples:
  $0
  $0 --help
eof
}

if [[ --help == $1 ]] ; then
        usage
        exit 0
else
Message=`tail /var/log/auth.log | grep "authentication failure" | tail -n 1`
while true ; do
        newMessage=`tail /var/log/auth.log | grep "authentication failure" | tail -n 1`
        if [ "$Message" != "$newMessage" ] ; then
                Message="$newMessage"
                type=`echo $Message | awk '{print $12}'`
                if [ "$type" == "tty=ssh" ] ; then
                        echo "Authentication failure by SSH"
                elif [ "$type" == "tty=/dev/tty1" ] ; then
                        echo "Authentication failure by virtual terminal"
                else
                        echo "Authentication failure by console"
                fi
        fi
        sleep 1

done
fi
