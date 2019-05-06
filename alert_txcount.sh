#!/bin/bash
DIR=/root/.scripts
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/alert_lib.sh"
getnode
. "$DIR/alert.conf"
. "/etc/setzer.conf"
ERROR=1
TX_COUNT_FILE="$DIR/tx.count"
for PORT in ${RPC_PORTS:-8545}; do
  export ETH_RPC_PORT=$PORT
  log "Trying on RPC port $ETH_RPC_PORT."
  if TX_COUNT=$(timeout $RPC_TIMEOUT /usr/local/bin/seth nonce $ACC); then 
  	if [ $TX_COUNT -gt $(/bin/cat $TX_COUNT_FILE)  ]; then
  		echo $TX_COUNT > $TX_COUNT_FILE
		ERROR=0
		log "Node running on RPC port $ETH_RPC_PORT"
  	fi
	break;
  fi
done
if [ $ERROR -eq 1 ]; then 
	printf "Vox alert feed not working!\r\n\r\n\
The feed has not been updated for more than 6 hours.\r\n\
We have not restarted any services.\r\n\
Check that geth and setzer service work properly!\r\n\r\n\
Best regards\r\n\
cron@"`hostname`":$DIR/alert_txcount.sh"\
|/usr/bin/mail -a "X-Priority:1" -s "Vox alert - feed not working!" $EMAIL
       	/usr/sbin/service parity restart
       	/usr/sbin/service geth restart
       	/usr/sbin/service setzer-bot restart
fi
