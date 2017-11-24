#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/alert_settings.sh"
ERROR=0
BLOCK_AGE_FILE="$DIR/block.age" 
if BLOCK_AGE=$(/bin/date --date="`/usr/local/bin/seth age`" +"%s"); then 
	if [ $BLOCK_AGE -gt $(/bin/cat $BLOCK_AGE_FILE)  ]; then
		echo $BLOCK_AGE > $BLOCK_AGE_FILE
	else 
		ERROR=1;
	fi
else
	ERROR=1;
fi
if [ $ERROR -eq 1 ]; then 
	printf "Alert from VOX!\r\n\r\n\
Geth is unavailable. Restarting geth.\r\n\r\n\
Best regards\r\n\
cron@"`hostname`":/root/.scripts/alert_ethereum.sh"\
|/usr/bin/mail -a "X-Priority:1" -s "Vox geth is down!" $EMAIL
       	/usr/sbin/service geth restart
fi
