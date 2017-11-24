#!/bin/bash
DOMAINNAME=`hostname`
USEDSPACE=`/bin/df|/bin/grep vda1|/bin/sed 's/.*\s\([0-9]\+\)%.*/\1/g'`
if (( $(echo "$USEDSPACE >= $DISK_SPACE_THRESHOLD" | bc -l)  )); then 
	printf "Alert from VOX!\r\n\r\n\
Disk usage is $USEDSPACE percent, please enlarge disk space for  $DOMAINNAME!\r\n\r\n\
Best regards\r\n\
cron@"`hostname`":/root/.scripts/alert_filesystem.sh" |/usr/bin/mail -a "X-Priority:1" -s "Vox disk usage $USEDSPACE%!" $EMAIL
fi
