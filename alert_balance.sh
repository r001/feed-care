#!/bin/bash
export PATH="$PATH:/usr/local/bin/:/usr/bin/"
DIR=/root/.scripts
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/alert_lib.sh"
getnode
. "$DIR/alert.conf"
BALANCE="$(/usr/local/bin/seth balance $ACC |/bin/sed  s/E.*//g)"
if (( $(echo "$BALANCE < $THRESHOLD" | bc -l)  )); then 
	printf "Alert from VOX!\r\n\r\n\
Balance is $BALANCE and it is less than $THRESHOLD .\r\n\
Please deposit into account $ACC !\r\n\r\n\
Best regards\r\n\
cron@"$(hostname)":$DIR/alert_balance.sh"\
|/usr/bin/mail -a "X-Priority:1" -s "Vox alert - balance low ($BALANCE ETH)!" $EMAIL
else
	log "Balance of $BALANCE is fine. (more than threshold of $THRESHOLD)"
fi
