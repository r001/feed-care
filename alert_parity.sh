#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/alert_lib.sh"
getnode
. "$DIR/alert.conf"
. "/etc/setzer.conf"
ERROR=0
BLOCK_AGE_FILE="$DIR/block_parity.age" 
export ETH_RPC_PORT=$PARITY_RPC_PORT
if BLOCK_AGE=$(/bin/date --date="`timeout $RPC_TIMEOUT /usr/local/bin/seth age`" +"%s"); then 
	if [ $BLOCK_AGE -gt $(/bin/cat $BLOCK_AGE_FILE)  ]; then
		echo $BLOCK_AGE > $BLOCK_AGE_FILE
	else 
		ERROR=1;
	fi
else
	ERROR=1;
fi
if [ $ERROR -eq 1 ]; then 
#	printf "Alert from VOX!\r\n\r\n\
#Parity is unavailable. Restarting parity.\r\n\r\n\
#Best regards\r\n\
#cron@"`hostname`":/root/.scripts/alert_parity.sh"\
#|/usr/bin/mail -a "X-Priority:1" -s "Vox alert - parity is down!" $EMAIL
       	/usr/sbin/service parity restart
fi
