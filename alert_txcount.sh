#!/bin/bash
DIR=/root/.scripts
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/alert_lib.sh"
getnode
. "$DIR/alert.conf"
. "/etc/setzer.conf"
TX_COUNT_FILE="$DIR/tx.count"
TX_COUNT="$(timeout $RPC_TIMEOUT /usr/local/bin/seth nonce $ACC || echo 0)"
if [ $TX_COUNT -gt $(/bin/cat $TX_COUNT_FILE) ]; then
	echo $TX_COUNT > $TX_COUNT_FILE
	log "Transaction counts are fine."
else
	log "Error: No transaction in the past 12 hours."
	printf "Vox alert feed not working!\r\n\r\n\
The feed has not been updated for more than 12 hours.\r\n\
We have not restarted any services.\r\n\
Check that geth and setzer service work properly!\r\n\r\n\
Best regards\r\n\
cron@"`hostname`":$DIR/alert_txcount.sh"\
|/usr/bin/mail -a "X-Priority:1" -s "Vox alert - feed not working!" $EMAIL
	/usr/sbin/service parity restart
	/usr/sbin/service geth restart
	/usr/sbin/service setzer-bot restart
fi
