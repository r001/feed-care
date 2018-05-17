#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/alert_lib.sh"
getnode
. "$DIR/alert.conf"
. "/etc/setzer.conf"
ERROR=0
BLOCK_AGE_FILE="$DIR/block_geth.age" 
export ETH_RPC_PORT=$GETH_RPC_PORT 
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
#Geth is unavailable. Restarting geth.\r\n\r\n\
#Best regards\r\n\
#cron@"`hostname`":/root/.scripts/alert_geth.sh"\
#|/usr/bin/mail -a "X-Priority:1" -s "Vox alert - geth is down!" $EMAIL
       	/usr/sbin/service geth restart
fi
