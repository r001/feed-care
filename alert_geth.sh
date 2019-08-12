#!/bin/bash
DIR=/root/.scripts
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/alert_lib.sh"
. "$DIR/alert.conf"
. "/etc/setzer.conf"
BLOCK_AGE_FILE="$DIR/block_geth.age"
if [ ! -f $BLOCK_AGE_FILE ]; then
	echo 0 > $BLOCK_AGE_FILE
fi
unset ETH_RPC_URL
export ETH_RPC_PORT=$GETH_RPC_PORT
BLOCK_AGE=$(/bin/date --date="$(timeout $RPC_TIMEOUT /usr/local/bin/seth age)" +"%s" || echo 0)
if [ $BLOCK_AGE -gt $(/bin/cat $BLOCK_AGE_FILE)  ]; then
	echo $BLOCK_AGE > $BLOCK_AGE_FILE
	log "Geth client is fine."
else
	#	printf "Alert from VOX!\r\n\r\n\
		#Geth is unavailable. Restarting geth.\r\n\r\n\
		#Best regards\r\n\
		#cron@"`hostname`":/root/.scripts/alert_geth.sh"\
		#|/usr/bin/mail -a "X-Priority:1" -s "Vox alert - geth is down!" $EMAIL
	/usr/sbin/service geth restart
	log "Error: geth client restarted."
fi
