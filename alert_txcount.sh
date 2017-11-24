#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/alert_settings.sh"
ERROR=0
TX_COUNT_FILE="$DIR/tx.count"
if TX_COUNT=$(/usr/local/bin/seth nonce $ACC); then 
	if [ $TX_COUNT -gt $(/bin/cat $TX_COUNT_FILE)  ]; then
		echo $TX_COUNT > $TX_COUNT_FILE
	else
		ERROR=1;
	fi
else
	ERROR=1;
fi
if [ $ERROR -eq 1 ]; then 
	printf "Alert from vox.tilaa.cloud!\r\n\r\n\
The feed has not been updated for more than 6 hours.\r\n\
We have not restarted any services.\r\n\
Check that geth and setzer service work properly!\r\n\r\n\
Best regards\r\n\
cron@vox.tilaa.cloud:/root/.scripts/alert_txcount.sh"\
|/usr/bin/mail -a "X-Priority:1" -s "Vox update does not work!" $EMAIL
       	/usr/sbin/service geth restart
       	/usr/sbin/service setzer-bot restart
fi
