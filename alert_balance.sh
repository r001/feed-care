#!/bin/bash
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/alert_settings.sh"
BALANCE=`/usr/local/bin/seth balance $ACC |/bin/sed  s/E.*//g`
if (( $(echo "$BALANCE < $THRESHOLD" | bc -l)  )); then 
	printf "Alert from VOX!\r\n\r\n\
Balance is $BALANCE and it is less than $THRESHOLD .\r\n\
Please deposit into account $ACC !\r\n\r\n\
Best regards\r\n\
cron@"`hostname`":/root/.scripts/alert_balance.sh"\
|/usr/bin/mail -a "X-Priority:1" -s "Vox alert - balance low ($BALANCE ETH)!" $EMAIL
fi
